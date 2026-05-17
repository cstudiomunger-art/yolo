import SwiftUI

struct LanguagePickerView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(AppLanguage.allCases) { language in
                Button {
                    appEnv.preferences.appLanguage = language
                    dismiss()
                } label: {
                    HStack {
                        Text(language.displayName)
                            .font(Theme.FontToken.inter(14))
                            .foregroundStyle(Theme.ColorToken.textPrimary)
                        Spacer()
                        if appEnv.preferences.appLanguage == language {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Theme.ColorToken.accent)
                        }
                    }
                }
            }
            .navigationTitle("Language")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
