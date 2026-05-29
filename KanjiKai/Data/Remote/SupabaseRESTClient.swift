//
//  SupabaseRESTClient.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 29/05/2026.
//

import Foundation

struct SupabaseRESTClient {
    private let configuration: SupabaseConfiguration
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder

    init(
        configuration: SupabaseConfiguration,
        urlSession: URLSession = .shared
    ) {
        self.configuration = configuration
        self.urlSession = urlSession
        self.jsonDecoder = JSONDecoder()
        self.jsonEncoder = JSONEncoder()
    }

    func select<Response: Decodable>(
        table: String,
        queryItems: [URLQueryItem],
        accessToken: String
    ) async throws -> [Response] {
        let request = try makeRequest(
            table: table,
            queryItems: queryItems,
            method: "GET",
            accessToken: accessToken
        )

        return try await send(request)
    }

    func upsert<Body: Encodable, Response: Decodable>(
        table: String,
        body: Body,
        onConflict: String,
        accessToken: String
    ) async throws -> [Response] {
        var request = try makeRequest(
            table: table,
            queryItems: [URLQueryItem(name: "on_conflict", value: onConflict)],
            method: "POST",
            accessToken: accessToken
        )
        request.setValue("resolution=merge-duplicates,return=representation", forHTTPHeaderField: "Prefer")
        request.httpBody = try jsonEncoder.encode(body)

        return try await send(request)
    }

    func patch<Body: Encodable, Response: Decodable>(
        table: String,
        body: Body,
        queryItems: [URLQueryItem],
        accessToken: String
    ) async throws -> [Response] {
        var request = try makeRequest(
            table: table,
            queryItems: queryItems,
            method: "PATCH",
            accessToken: accessToken
        )
        request.setValue("return=representation", forHTTPHeaderField: "Prefer")
        request.httpBody = try jsonEncoder.encode(body)

        return try await send(request)
    }

    private func makeRequest(
        table: String,
        queryItems: [URLQueryItem],
        method: String,
        accessToken: String
    ) throws -> URLRequest {
        var url = configuration.projectURL
        url.appendPathComponent("rest/v1")
        url.appendPathComponent(table)

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw SupabaseRESTError.invalidURL
        }
        components.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let requestURL = components.url else {
            throw SupabaseRESTError.invalidURL
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = method
        request.setValue(configuration.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    private func send<Response: Decodable>(_ request: URLRequest) async throws -> [Response] {
        let (data, response) = try await urlSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw SupabaseRESTError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            let message = String(data: data, encoding: .utf8)
            throw SupabaseRESTError.requestFailed(statusCode: httpResponse.statusCode, message: message)
        }

        guard !data.isEmpty else {
            return []
        }

        return try jsonDecoder.decode([Response].self, from: data)
    }
}

enum SupabaseRESTError: LocalizedError {
    case invalidURL
    case invalidResponse
    case requestFailed(statusCode: Int, message: String?)
    case emptyResult

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Invalid Supabase REST URL."
        case .invalidResponse:
            "Invalid Supabase REST response."
        case .requestFailed(let statusCode, let message):
            "Supabase request failed with status \(statusCode): \(message ?? "No response body")"
        case .emptyResult:
            "Supabase returned no rows."
        }
    }
}
