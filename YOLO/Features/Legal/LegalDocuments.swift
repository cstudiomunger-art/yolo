import Foundation

enum LegalDocumentKind: String, Identifiable {
    case privacy
    case terms
    case gdpr
    case aiDisclosure

    var id: String { rawValue }

    var navigationTitle: String {
        switch self {
        case .privacy: String(localized: "Privacy Policy")
        case .terms: String(localized: "Terms of Service")
        case .gdpr: String(localized: "GDPR Compliance Framework")
        case .aiDisclosure: String(localized: "AI Content Disclosure")
        }
    }

    func resolvedHTML(branding: AppBranding) -> String {
        let cms = switch self {
        case .privacy: branding.privacyPolicyBody
        case .terms: branding.termsOfServiceBody
        case .gdpr: branding.gdprComplianceBody
        case .aiDisclosure: branding.aiContentDisclosureBody
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
        case .gdpr: Self.gdprHTML
        case .aiDisclosure: Self.aiDisclosureHTML
        }
    }

    private static let privacyHTML = """
    <h2>Privacy Policy</h2>
    <p><strong>Last updated:</strong> June 2026</p>
    <p>YOLO HAPPY explains how we handle your information when you use our iOS app and related services.</p>
    <h3>Contact</h3>
    <p>Privacy: chengduyuliutech@163.com · Support: support@yolohappy.app</p>
    """

    private static let termsHTML = """
    <h2>Terms of Service</h2>
    <p><strong>Last updated:</strong> June 2026</p>
    <p>By using YOLO HAPPY you agree to these terms. Content is for general information only and not professional travel or legal advice.</p>
    <h3>Contact</h3>
    <p>support@yolohappy.app</p>
    """

    private static let gdprHTML = """
    <h2>GDPR Compliance Framework</h2>
    <p><strong>Effective:</strong> June 2026</p>
    <p>This framework describes how Chengdu Yuliu Technology Co., Ltd. processes personal data for YOLO HAPPY users in the EU/EEA, including legal bases, data subject rights, and breach response.</p>
    <h3>Contact</h3>
    <p>Data protection: chengduyuliutech@163.com</p>
    """

    private static let aiDisclosureHTML = """
    <h2>AI Content Disclosure</h2>
    <p><strong>Version:</strong> v2.0 · June 2026</p>
    <p>YOLO HAPPY uses AI (Volcengine Ark) to assist with itinerary planning and travel dialogue. AI output is for travel reference only — verify critical details independently. Non-AI paths are available.</p>
    """
}
