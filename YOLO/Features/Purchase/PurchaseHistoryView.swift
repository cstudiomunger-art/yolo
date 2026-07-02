import Supabase
import SwiftUI

struct PurchaseHistoryView: View {
    @Environment(AppEnvironment.self) private var appEnv

    @State private var transactions: [IAPTransaction] = []
    @State private var isLoading = true
    @State private var loadError: String?
    @State private var showLogin = false

    var body: some View {
        Group {
            if appEnv.mustSignInForAccountAction {
                AccountSignInPrompt(
                    title: String(localized: "Sign in to view purchases"),
                    message: String(localized: "Your purchase history is linked to your account.")
                ) {
                    showLogin = true
                }
            } else if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if transactions.isEmpty {
                VStack(spacing: 12) {
                    Text(String(localized: "No purchases yet"))
                        .font(Theme.FontToken.playfair(16, weight: .semibold))
                    Text(String(localized: "Your purchase history will appear here after your first transaction."))
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .multilineTextAlignment(.center)
                }
                .padding(Theme.screenPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(transactions) { tx in
                    TransactionRow(transaction: tx)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(String(localized: "Purchase History"))
        .navigationBarTitleDisplayMode(.inline)
        .loginSheet(isPresented: $showLogin, appEnv: appEnv)
        .task { await load() }
        .overlay(alignment: .top) {
            if let loadError {
                Text(loadError)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(.red)
                    .padding(Theme.screenPadding)
            }
        }
    }

    private func load() async {
        guard !appEnv.mustSignInForAccountAction else {
            isLoading = false
            return
        }
        isLoading = true
        loadError = nil
        defer { isLoading = false }
        guard let userId = appEnv.auth.userId,
              AppConfig.isSupabaseConfigured else { return }
        do {
            let rows: [IAPTransaction] = try await SupabaseManager.shared
                .from("user_iap_transactions")
                .select()
                .eq("user_id", value: userId.uuidString)
                .order("purchased_at", ascending: false)
                .execute()
                .value
            transactions = rows
        } catch {
            loadError = error.localizedDescription
        }
    }
}

private struct TransactionRow: View {
    let transaction: IAPTransaction

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(transaction.eventTypeLabel)
                    .font(Theme.FontToken.inter(13, weight: .medium))
                Spacer()
                if let price = transaction.priceUsd {
                    Text(String(format: "$%.2f", price))
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            }
            Text(transaction.productId)
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
            if let date = transaction.purchasedDate {
                Text(date, style: .date)
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(Theme.ColorToken.textGhost)
            }
        }
        .padding(.vertical, 4)
    }
}

struct IAPTransaction: Identifiable, Codable {
    let id: UUID
    let productId: String
    let eventType: String
    let priceUsd: Double?
    let currency: String?
    // timestamptz columns arrive as ISO8601 strings; the shared decoder has no
    // date strategy, so receive as String (project convention) and parse for display.
    let purchasedAt: String
    let expiresAt: String?
    let planId: String?

    var purchasedDate: Date? {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f.date(from: purchasedAt) ?? ISO8601DateFormatter().date(from: purchasedAt)
    }

    var eventTypeLabel: String {
        switch eventType {
        case "INITIAL_PURCHASE": return String(localized: "Purchase")
        case "RENEWAL": return String(localized: "Renewal")
        case "REFUND": return String(localized: "Refund")
        case "CANCELLATION": return String(localized: "Cancelled")
        case "EXPIRATION": return String(localized: "Expired")
        case "NON_RENEWING_PURCHASE": return String(localized: "One-time Purchase")
        default: return eventType
        }
    }

    // camelCase keys — Supabase decoder uses .convertFromSnakeCase (product_id →
    // productId). Snake_case raw values would break decoding (history reads empty).
    enum CodingKeys: String, CodingKey {
        case id
        case productId
        case eventType
        case priceUsd
        case currency
        case purchasedAt
        case expiresAt
        case planId
    }
}
