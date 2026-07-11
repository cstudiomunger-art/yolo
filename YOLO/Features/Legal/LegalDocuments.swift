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

    func resolvedMarkdown(branding: AppBranding) -> String {
        let cms = switch self {
        case .privacy: branding.privacyPolicyBody
        case .terms: branding.termsOfServiceBody
        case .gdpr: branding.gdprComplianceBody
        case .aiDisclosure: branding.aiContentDisclosureBody
        }
        if !cms.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return cms
        }
        return bundledMarkdown
    }

    private var bundledMarkdown: String {
        switch self {
        case .privacy: Self.privacyMarkdown
        case .terms: Self.termsMarkdown
        case .gdpr: Self.gdprMarkdown
        case .aiDisclosure: Self.aiDisclosureMarkdown
        }
    }

    private static let privacyMarkdown = """
    ## Privacy Policy

    **Last updated:** June 2026

    YOLO HAPPY explains how we handle your information when you use our iOS app and related services.

    ### Contact

    Privacy: chengduyuliutech@163.com · Support: support@yolohappy.app
    """

    private static let termsMarkdown = """
    ## Terms of Service

    **Last updated:** June 2026

    By using YOLO HAPPY you agree to these terms. Content is for general information only and not professional travel or legal advice.

    ### Contact

    support@yolohappy.app
    """

    private static let gdprMarkdown = """
    ## GDPR Compliance Framework

    **Effective:** June 2026

    This framework describes how Chengdu Yuliu Technology Co., Ltd. processes personal data for YOLO HAPPY users in the EU/EEA, including legal bases, data subject rights, and breach response.

    ### Contact

    Data protection: chengduyuliutech@163.com
    """

    private static let aiDisclosureMarkdown = """
    ## AI Content Disclosure

    **Version:** v2.0 · June 2026

    YOLO HAPPY uses AI (Volcengine Ark) to assist with itinerary planning and travel dialogue. AI output is for travel reference only — verify critical details independently. Non-AI paths are available.
    """
}
