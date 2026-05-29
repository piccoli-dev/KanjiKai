//
//  RemoteProfileRepository.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 29/05/2026.
//

import Foundation

struct RemoteProfile: Hashable, Decodable {
    let id: String
    let name: String
    let email: String?
    let level: String
    let dailyGoal: Int
    let nativeLanguage: String
    let easyMode: Bool

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case level
        case dailyGoal = "daily_goal"
        case nativeLanguage = "native_language"
        case easyMode = "easy_mode"
    }
}

struct RemoteProfileSettingsUpdate: Encodable {
    var name: String?
    var level: String?
    var dailyGoal: Int?
    var nativeLanguage: String?
    var easyMode: Bool?

    private enum CodingKeys: String, CodingKey {
        case name
        case level
        case dailyGoal = "daily_goal"
        case nativeLanguage = "native_language"
        case easyMode = "easy_mode"
    }
}

struct RemoteProfileRepository {
    private let client: SupabaseRESTClient

    init(client: SupabaseRESTClient) {
        self.client = client
    }

    func fetchProfile(userID: String, accessToken: String) async throws -> RemoteProfile {
        let rows: [RemoteProfile] = try await client.select(
            table: "profiles",
            queryItems: [
                URLQueryItem(name: "select", value: "*"),
                URLQueryItem(name: "id", value: "eq.\(userID)"),
                URLQueryItem(name: "limit", value: "1")
            ],
            accessToken: accessToken
        )

        guard let profile = rows.first else {
            throw SupabaseRESTError.emptyResult
        }

        return profile
    }

    func updateSettings(
        userID: String,
        update: RemoteProfileSettingsUpdate,
        accessToken: String
    ) async throws -> RemoteProfile {
        let rows: [RemoteProfile] = try await client.patch(
            table: "profiles",
            body: update,
            queryItems: [
                URLQueryItem(name: "id", value: "eq.\(userID)")
            ],
            accessToken: accessToken
        )

        guard let profile = rows.first else {
            throw SupabaseRESTError.emptyResult
        }

        return profile
    }
}
