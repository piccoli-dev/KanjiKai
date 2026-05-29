//
//  RemoteLearningProgressRepository.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 29/05/2026.
//

import Foundation

struct RemoteKanjiProgress: Hashable {
    let userID: String
    let kanjiOrder: Int
    let completedAt: Date?
    let isFavorite: Bool
    let updatedAt: Date?
}

struct RemoteLearningProgressRepository {
    private let client: SupabaseRESTClient

    init(client: SupabaseRESTClient) {
        self.client = client
    }

    func fetchProgress(userID: String, accessToken: String) async throws -> [RemoteKanjiProgress] {
        let rows: [RemoteKanjiProgressRow] = try await client.select(
            table: "user_kanji_progress",
            queryItems: [
                URLQueryItem(name: "select", value: "*"),
                URLQueryItem(name: "user_id", value: "eq.\(userID)"),
                URLQueryItem(name: "order", value: "kanji_order.asc")
            ],
            accessToken: accessToken
        )

        return rows.map(\.progress)
    }

    func upsertCompletedKanji(
        userID: String,
        kanjiOrder: Int,
        completedAt: Date = .now,
        accessToken: String
    ) async throws -> RemoteKanjiProgress {
        let body = RemoteKanjiProgressUpsert(
            userID: userID,
            kanjiOrder: kanjiOrder,
            completedAt: DateCoding.string(from: completedAt),
            isFavorite: nil
        )

        return try await upsert(body: body, accessToken: accessToken)
    }

    func upsertFavoriteKanji(
        userID: String,
        kanjiOrder: Int,
        isFavorite: Bool,
        accessToken: String
    ) async throws -> RemoteKanjiProgress {
        let body = RemoteKanjiProgressUpsert(
            userID: userID,
            kanjiOrder: kanjiOrder,
            completedAt: nil,
            isFavorite: isFavorite
        )

        return try await upsert(body: body, accessToken: accessToken)
    }

    private func upsert(
        body: RemoteKanjiProgressUpsert,
        accessToken: String
    ) async throws -> RemoteKanjiProgress {
        let rows: [RemoteKanjiProgressRow] = try await client.upsert(
            table: "user_kanji_progress",
            body: body,
            onConflict: "user_id,kanji_order",
            accessToken: accessToken
        )

        guard let row = rows.first else {
            throw SupabaseRESTError.emptyResult
        }

        return row.progress
    }
}

private struct RemoteKanjiProgressRow: Decodable {
    let userID: String
    let kanjiOrder: Int
    let completedAt: String?
    let isFavorite: Bool
    let updatedAt: String?

    var progress: RemoteKanjiProgress {
        RemoteKanjiProgress(
            userID: userID,
            kanjiOrder: kanjiOrder,
            completedAt: DateCoding.date(from: completedAt),
            isFavorite: isFavorite,
            updatedAt: DateCoding.date(from: updatedAt)
        )
    }

    private enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case kanjiOrder = "kanji_order"
        case completedAt = "completed_at"
        case isFavorite = "is_favorite"
        case updatedAt = "updated_at"
    }
}

private struct RemoteKanjiProgressUpsert: Encodable {
    let userID: String
    let kanjiOrder: Int
    let completedAt: String?
    let isFavorite: Bool?

    private enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case kanjiOrder = "kanji_order"
        case completedAt = "completed_at"
        case isFavorite = "is_favorite"
    }
}

private enum DateCoding {
    private static let fractionalFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private static let standardFormatter = ISO8601DateFormatter()

    static func string(from date: Date) -> String {
        fractionalFormatter.string(from: date)
    }

    static func date(from string: String?) -> Date? {
        guard let string else { return nil }
        return fractionalFormatter.date(from: string) ?? standardFormatter.date(from: string)
    }
}
