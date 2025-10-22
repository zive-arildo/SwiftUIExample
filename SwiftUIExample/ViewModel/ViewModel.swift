//
//  ViewModel.swift
//  SwiftUIExample
//
//  Created by Arildo Junior on 22/10/25.
//

import Combine
import Foundation

final class ViewModel: ObservableObject {
    @Published private(set) var repositories: [RepositoryResponse] = []
    @Published private(set) var loadingState: LoadingState = .loading

    init() {
        Task { await fetchRepositories() }
    }

    func fetchRepositories() async {
        await MainActor.run { self.loadingState = .loading }

        guard var components = URLComponents(string: Constants.searchRepoUrl) else {
            await MainActor.run { self.loadingState = .failed }
            return
        }

        components.queryItems = [
            URLQueryItem(name: "q", value: "stars:>=0"),
            URLQueryItem(name: "sort", value: "updated"),
            URLQueryItem(name: "order", value: "desc")
        ]

        guard let url = components.url else {
            await MainActor.run { self.loadingState = .failed }
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            let response = try await MainActor.run { () -> SearchRepositoryResponse in
                try JSONDecoder().decode(SearchRepositoryResponse.self, from: data)
            }

            await MainActor.run {
                self.repositories = response.items ?? []
                self.loadingState = .success
            }
        } catch {
            await MainActor.run {
                self.loadingState = .failed
            }
            print("Error fetching repositories: \(error)")
        }
    }
}
