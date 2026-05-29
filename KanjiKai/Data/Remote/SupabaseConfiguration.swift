//
//  SupabaseConfiguration.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 29/05/2026.
//

import Foundation

struct SupabaseConfiguration: Hashable {
    let projectURL: URL
    let anonKey: String

    static func fromBundle(_ bundle: Bundle = .main) throws -> SupabaseConfiguration {
        guard let urlString = bundle.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
              let projectURL = URL(string: urlString),
              !urlString.isEmpty else {
            throw SupabaseConfigurationError.missingProjectURL
        }

        guard let anonKey = bundle.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String,
              !anonKey.isEmpty else {
            throw SupabaseConfigurationError.missingAnonKey
        }

        return SupabaseConfiguration(projectURL: projectURL, anonKey: anonKey)
    }
}

enum SupabaseConfigurationError: LocalizedError {
    case missingProjectURL
    case missingAnonKey

    var errorDescription: String? {
        switch self {
        case .missingProjectURL:
            "Missing SUPABASE_URL in Info.plist."
        case .missingAnonKey:
            "Missing SUPABASE_ANON_KEY in Info.plist."
        }
    }
}
