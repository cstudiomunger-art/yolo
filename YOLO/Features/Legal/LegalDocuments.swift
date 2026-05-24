import Foundation

enum LegalDocumentKind: String, Identifiable {
    case privacy
    case terms

    var id: String { rawValue }

    var navigationTitle: String {
        switch self {
        case .privacy: String(localized: "Privacy Policy")
        case .terms: String(localized: "Terms of Service")
        }
    }

    func resolvedHTML(branding: AppBranding) -> String {
        let cms = switch self {
        case .privacy: branding.privacyPolicyBody
        case .terms: branding.termsOfServiceBody
        }
        if !cms.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return cms
        }
        return bundledHTML
    }

    private var bundledHTML: String {
        switch self {
        case .privacy: Self.privacyHTML
        case .terms: Self.termsHTML
        }
    }

    private static let privacyHTML = """
    <h2>Privacy Policy</h2>
    <p><strong>Last updated:</strong> May 2026</p>
    <p>YOLO HAPPY ("we", "our") explains how we handle your information when you use our iOS app and related services.</p>
    <h3>Information we collect</h3>
    <ul>
    <li><strong>Account:</strong> email address and authentication data when you sign up.</li>
    <li><strong>Trip data:</strong> itineraries, checklist progress, nationality, and departure date you provide.</li>
    <li><strong>Usage:</strong> basic analytics events (e.g. screens opened, share link created) to improve the product.</li>
    <li><strong>Diagnostics:</strong> crash and performance data to fix stability issues.</li>
    </ul>
    <h3>How we use information</h3>
    <p>We use your data to sync trips across devices, deliver reminders, operate audio guides, and improve app reliability. We do not sell your personal information.</p>
    <h3>Sharing</h3>
    <p>When you enable itinerary sharing, a read-only link is generated. Anyone with the link can view that itinerary until you turn sharing off.</p>
    <h3>Retention & deletion</h3>
    <p>You may delete your account in Profile. This removes your account and associated cloud data subject to backup retention limits.</p>
    <h3>Contact</h3>
    <p>Questions: support@yolohappy.app</p>
    """

    private static let termsHTML = """
    <h2>Terms of Service</h2>
    <p><strong>Last updated:</strong> May 2026</p>
    <p>By using YOLO HAPPY you agree to these terms.</p>
    <h3>Service</h3>
    <p>YOLO HAPPY provides travel planning content, AI-assisted itineraries, audio guides, and preparation checklists. Content is for general information only and not professional travel or legal advice.</p>
    <h3>Accounts</h3>
    <p>You are responsible for safeguarding your login credentials. You must provide accurate information and comply with applicable laws.</p>
    <h3>Acceptable use</h3>
    <p>Do not misuse the service, attempt unauthorized access, or upload unlawful content.</p>
    <h3>Subscriptions & purchases</h3>
    <p>In-app purchases may be offered separately under platform terms. Refunds follow Apple App Store policies where applicable.</p>
    <h3>Limitation of liability</h3>
    <p>The app is provided "as is". We are not liable for indirect damages arising from travel decisions based on app content.</p>
    <h3>Contact</h3>
    <p>support@yolohappy.app</p>
    """
}
