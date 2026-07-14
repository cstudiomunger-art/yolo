import Foundation
import Supabase

enum SupabaseManager {
    static let shared: SupabaseClient = {
        SupabaseClient(
            supabaseURL: GatewayFallback.preferredSupabaseURL,
            supabaseKey: AppConfig.supabaseAnonKey,
            options: SupabaseClientOptions(
                db: SupabaseClientOptions.DatabaseOptions(
                    encoder: JSONCoding.makeEncoder(),
                    decoder: JSONCoding.makeDecoder()
                ),
                auth: SupabaseClientOptions.AuthOptions(
                    emitLocalSessionAsInitialSession: true
                )
            )
        )
    }()
}
