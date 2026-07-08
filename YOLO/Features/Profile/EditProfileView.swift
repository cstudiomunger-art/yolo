import PhotosUI
import Supabase
import SwiftUI

struct EditProfileView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    @State private var displayName: String = ""
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedUIImage: UIImage?
    @State private var isUploadingAvatar = false
    @State private var isSavingName = false
    @State private var nameError: String?
    @State private var avatarError: String?

    private static let forbiddenWords: Set<String> = [
        "fuck", "shit", "ass", "bitch", "dick", "pussy", "cunt", "nigger", "nigga",
        "asshole", "bastard", "motherfucker",
        "操", "草", "妈的", "他妈", "狗日", "日你", "你妈", "傻逼", "煞笔", "王八"
    ]

    var body: some View {
        NavigationStack {
            Form {
                avatarSection
                nameSection
            }
            .navigationTitle(String(localized: "Edit Profile"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Save")) {
                        Task { await save() }
                    }
                    .disabled(isSavingName || isUploadingAvatar)
                }
            }
            .onAppear {
                displayName = appEnv.preferences.displayName ?? ""
            }
            .onChange(of: selectedPhotoItem) { _, item in
                Task { await handlePhotoSelection(item) }
            }
        }
        .sheetDragToDismiss()
    }

    // MARK: - Sections

    private var avatarSection: some View {
        Section {
            HStack {
                Spacer()
                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    ZStack(alignment: .bottomTrailing) {
                        Group {
                            if let img = selectedUIImage {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            } else {
                                ProfileAvatarButton(
                                    avatarUrl: appEnv.preferences.avatarUrl,
                                    displayName: appEnv.preferences.displayName,
                                    size: 80,
                                    action: {}
                                )
                                .allowsHitTesting(false)
                            }
                        }

                        Image(systemName: "camera.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(.white)
                            .frame(width: 26, height: 26)
                            .background(Theme.ColorToken.accent)
                            .clipShape(Circle())
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .listRowBackground(Color.clear)

            if isUploadingAvatar {
                HStack {
                    ProgressView()
                    Text(String(localized: "Uploading…"))
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            }
            if let avatarError {
                Text(avatarError)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(.red)
                // Avatar bucket is created by migration 051 — needs supabase db push
                if avatarError.lowercased().contains("not found") ||
                   avatarError.lowercased().contains("bucket") ||
                   avatarError.lowercased().contains("storage") {
                    Text(String(localized: "Storage bucket not set up yet. Run: supabase db push"))
                        .font(Theme.FontToken.inter(10))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            }
        }
    }

    private var nameSection: some View {
        Section {
            TextField(String(localized: "Display name"), text: $displayName)
                .autocorrectionDisabled()
        } footer: {
            Text(String(localized: "2–30 characters. Shown to other users."))
                .font(Theme.FontToken.inter(10))

            if let nameError {
                Text(nameError)
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(.red)
            }
        }
    }


    // MARK: - Actions

    private func save() async {
        nameError = nil
        let trimmed = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else {
            nameError = String(localized: "Name must be at least 2 characters.")
            return
        }
        guard trimmed.count <= 30 else {
            nameError = String(localized: "Name must be 30 characters or fewer.")
            return
        }
        let lower = trimmed.lowercased()
        if Self.forbiddenWords.contains(where: { lower.contains($0) }) {
            nameError = String(localized: "This name is not allowed.")
            return
        }

        isSavingName = true
        defer { isSavingName = false }
        appEnv.preferences.displayName = trimmed
        appEnv.profileSync.schedulePush()
        dismiss()
    }

    private func handlePhotoSelection(_ item: PhotosPickerItem?) async {
        guard let item else { return }
        avatarError = nil
        guard let data = try? await item.loadTransferable(type: Data.self),
              let uiImage = UIImage(data: data) else {
            avatarError = String(localized: "Could not load the selected image.")
            return
        }
        let cropped = cropToSquare(uiImage)
        let resized = resize(cropped, to: CGSize(width: 200, height: 200))
        selectedUIImage = resized
        await uploadAvatar(resized)
    }

    private func uploadAvatar(_ image: UIImage) async {
        guard let userId = appEnv.auth.userId else { return }
        guard let jpegData = image.jpegData(compressionQuality: 0.85) else { return }

        isUploadingAvatar = true
        avatarError = nil
        defer { isUploadingAvatar = false }

        // Supabase auth.uid()::text returns lowercase UUID — path must match exactly
        let path = "\(userId.uuidString.lowercased())/avatar.jpg"
        do {
            _ = try await SupabaseManager.shared.storage
                .from("avatars")
                .upload(path, data: jpegData, options: FileOptions(contentType: "image/jpeg", upsert: true))

            // The storage path is fixed (userId/avatar.jpg, upsert), so the public
            // URL is identical across re-uploads. Append a version query so every
            // cache layer (our disk/memory cache + URLSession) treats a new upload
            // as a new image and all screens refresh immediately.
            let baseURL = try SupabaseManager.shared.storage
                .from("avatars")
                .getPublicURL(path: path)
                .absoluteString
            let publicURL = "\(baseURL)?v=\(Int(Date().timeIntervalSince1970))"

            appEnv.preferences.avatarUrl = publicURL
            appEnv.preferences.avatarStatus = "approved"
            appEnv.profileSync.schedulePush()
        } catch {
            avatarError = error.localizedDescription
        }
    }

    // MARK: - Image helpers

    // Use UIGraphicsImageRenderer for both crop and resize so that EXIF orientation is
    // applied correctly and the resulting image always has scale=1 upright pixels.
    private func cropToSquare(_ image: UIImage) -> UIImage {
        let side = min(image.size.width, image.size.height)
        let origin = CGPoint(
            x: (image.size.width - side) / 2,
            y: (image.size.height - side) / 2
        )
        let squareSize = CGSize(width: side, height: side)
        return UIGraphicsImageRenderer(size: squareSize).image { _ in
            image.draw(at: CGPoint(x: -origin.x, y: -origin.y))
        }
    }

    private func resize(_ image: UIImage, to size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
