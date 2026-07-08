import SwiftUI

extension View {
    /// Standard sheet presentation: drag indicator, swipe-down dismiss, scroll-friendly interaction.
    func sheetDragToDismiss() -> some View {
        presentationDragIndicator(.visible)
            .interactiveDismissDisabled(false)
            .presentationContentInteraction(.scrolls)
    }
}
