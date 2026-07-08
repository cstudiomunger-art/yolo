import SwiftUI
import UIKit

/// Re-enables UIKit edge swipe-back when the system back button is hidden.
private struct NavigationSwipeBackEnabler: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> EnablerViewController {
        EnablerViewController()
    }

    func updateUIViewController(_ uiViewController: EnablerViewController, context: Context) {
        uiViewController.scheduleRefreshGesture()
    }

    final class EnablerViewController: UIViewController, UIGestureRecognizerDelegate {
        private var refreshScheduled = false

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            scheduleRefreshGesture()
        }

        func scheduleRefreshGesture() {
            guard !refreshScheduled else { return }
            refreshScheduled = true
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                refreshScheduled = false
                refreshGesture()
            }
        }

        func refreshGesture() {
            guard let nav = resolvedNavigationController(),
                  let pop = nav.interactivePopGestureRecognizer else { return }

            let shouldEnable = nav.viewControllers.count > 1
            if pop.isEnabled != shouldEnable {
                pop.isEnabled = shouldEnable
            }
            if pop.delegate !== self {
                pop.delegate = self
            }
        }

        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            guard let nav = resolvedNavigationController() else { return false }
            return nav.viewControllers.count > 1
        }

        private func resolvedNavigationController() -> UINavigationController? {
            if let navigationController { return navigationController }

            var current: UIViewController? = parent
            while let controller = current {
                if let nav = controller as? UINavigationController { return nav }
                if let nav = controller.navigationController { return nav }
                current = controller.parent
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
            resolvedNavigationController()?.interactivePopGestureRecognizer?.isEnabled = false
        }

        private func resolvedNavigationController() -> UINavigationController? {
            if let navigationController { return navigationController }

            var current: UIViewController? = parent
            while let controller = current {
                if let nav = controller as? UINavigationController { return nav }
                if let nav = controller.navigationController { return nav }
                current = controller.parent
            }
            return nil
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
