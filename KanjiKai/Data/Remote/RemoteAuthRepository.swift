//
//  RemoteAuthRepository.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 29/05/2026.
//

import Foundation

struct RemoteAuthSession: Hashable, Decodable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let tokenType: String
    let user: RemoteAuthenticatedUser

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case user
    }
}

struct RemoteAuthenticatedUser: Hashable, Decodable {
    let id: String
    let email: String?
}

struct RemoteAuthRepository {
    private let configuration: SupabaseConfiguration
    private let urlSession: URLSession
    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()

    init(
        configuration: SupabaseConfiguration,
        urlSession: URLSession = .shared
    ) {
        self.configuration = configuration
        self.urlSession = urlSession
    }

    func signIn(email: String, password: String) async throws -> RemoteAuthSession {
        var request = try makeAuthRequest(
            path: "token",
            queryItems: [URLQueryItem(name: "grant_type", value: "password")]
        )
        request.httpBody = try jsonEncoder.encode(RemoteAuthCredentials(email: email, password: password))
        return try await send(request)
    }

    func signUp(email: String, password: String) async throws -> RemoteAuthSession {
        var request = try makeAuthRequest(path: "signup")
        request.httpBody = try jsonEncoder.encode(RemoteAuthCredentials(email: email, password: password))
        return try await send(request)
    }

    private func makeAuthRequest(
        path: String,
        queryItems: [URLQueryItem] = []
    ) throws -> URLRequest {
        var url = configuration.projectURL
        url.appendPathComponent("auth/v1")
        url.appendPathComponent(path)

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw SupabaseRESTError.invalidURL
        }
        components.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let requestURL = components.url else {
            throw SupabaseRESTError.invalidURL
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue(configuration.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(configuration.anonKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    private func send<Response: Decodable>(_ request: URLRequest) async throws -> Response {
        let (data, response) = try await urlSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw SupabaseRESTError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            let message = String(data: data, encoding: .utf8)
            throw SupabaseRESTError.requestFailed(statusCode: httpResponse.statusCode, message: message)
        }

        return try jsonDecoder.decode(Response.self, from: data)
    }
}

private struct RemoteAuthCredentials: Encodable {
    let email: String
    let password: String
}
