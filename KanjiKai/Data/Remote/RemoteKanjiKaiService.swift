//
//  RemoteKanjiKaiService.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 29/05/2026.
//

import Foundation

struct RemoteKanjiKaiService {
    let auth: RemoteAuthRepository
    let profiles: RemoteProfileRepository
    let progress: RemoteLearningProgressRepository

    init(configuration: SupabaseConfiguration) {
        let restClient = SupabaseRESTClient(configuration: configuration)
        self.auth = RemoteAuthRepository(configuration: configuration)
        self.profiles = RemoteProfileRepository(client: restClient)
        self.progress = RemoteLearningProgressRepository(client: restClient)
    }

    static func fromBundle(_ bundle: Bundle = .main) throws -> RemoteKanjiKaiService {
        try RemoteKanjiKaiService(configuration: SupabaseConfiguration.fromBundle(bundle))
    }
}
