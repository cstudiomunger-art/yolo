import SwiftUI
import UIKit

/// Re-enables UIKit edge swipe-back when the system back button is hidden.
private struct NavigationSwipeBackEnabler: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> EnablerViewController {
        EnablerViewController()
    }

    func updateUIViewController(_ uiViewController: EnablerViewController, context: Context) {
        uiViewController.refreshGesture()
    }

    final class EnablerViewController: UIViewController, UIGestureRecognizerDelegate {
        private weak var observedNavigationController: UINavigationController?

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            refreshGesture()
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            refreshGesture()
        }

        func refreshGesture() {
            guard let nav = resolvedNavigationController(),
                  let pop = nav.interactivePopGestureRecognizer else { return }
            observedNavigationController = nav
            pop.isEnabled = nav.viewControllers.count > 1
            pop.delegate = self
        }

        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            (resolvedNavigationController()?.viewControllers.count ?? 0) > 1
        }

        private func resolvedNavigationController() -> UINavigationController? {
            if let navigationController { return navigationController }

            var current: UIViewController? = parent
            while let controller = current {
                if let nav = controller as? UINavigationController { return nav }
                if let nav = controller.navigationController { return nav }
                current = controller.parent
            }

            return findNavigationController(in: view.window?.rootViewController)
        }

        private func findNavigationController(in root: UIViewController?) -> UINavigationController? {
            guard let root else { return nil }
            if let nav = root as? UINavigationController { return nav }
            if let nav = root.navigationController, nav.viewControllers.contains(root) { return nav }
            for child in root.children {
                if let nav = findNavigationController(in: child) { return nav }
            }
            if let presented = root.presentedViewController {
                return findNavigationController(in: presented)
            }
            return nil
        }
    }
}

/// Disables the system pop gesture when a custom swipe-back action is used.
private struct NavigationSwipeBackDisabler: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> DisablerViewController {
        DisablerViewController()
    }

    func updateUIViewController(_ uiViewController: DisablerViewController, context: Context) {}

    final class DisablerViewController: UIViewController {
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}

private struct NavigationSwipeBackActionModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .background(NavigationSwipeBackDisabler())
            .overlay(alignment: .leading) {
                Color.clear
                    .frame(width: 28)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 12, coordinateSpace: .global)
                            .onEnded { value in
                                let dx = value.translation.width
                                let dy = value.translation.height
                                guard value.startLocation.x < 44,
                                      dx > 80,
                                      abs(dx) > abs(dy) else { return }
                                action()
                            }
                    )
            }
    }
}

extension View {
    /// Re-enable UIKit edge swipe-back while keeping a custom toolbar back button.
    func navigationSwipeBackEnabled(_ enabled: Bool = true) -> some View {
        background {
            if enabled {
                NavigationSwipeBackEnabler()
                    .frame(width: 0, height: 0)
            }
        }
    }

    /// Custom swipe-back action (e.g. cross-tab return). Disables default pop.
    func navigationSwipeBack(action: @escaping () -> Void) -> some View {
        modifier(NavigationSwipeBackActionModifier(action: action))
    }
}
