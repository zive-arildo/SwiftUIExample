//
//  ContentView.swift
//  SwiftUIExample
//
//  Created by Arildo Junior on 22/10/25.
//

import Combine
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.loadingState {
                case .loading:
                    VStack {
                        Spacer()
                        ProgressView("Loading repositories…")
                            .progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }
                case .failed:
                    VStack(spacing: 16) {
                        Image(systemName: "wifi.exclamationmark")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("Unable to load repositories")
                            .font(.headline)
                        Text("Check your connection and try again.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Button(action: {
                            Task { await viewModel.fetchRepositories() }
                        }) {
                            Text("Retry")
                                .bold()
                                .frame(minWidth: 120)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                case .success:
                    if viewModel.repositories.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "tray")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                            Text("No repositories found")
                                .font(.headline)
                            Text("Try adjusting the search or check back later.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    } else {
                        List(viewModel.repositories) { repo in
                            NavigationLink(destination: DetailView(repo: repo)) {
                                RepoRow(repo: repo)
                            }
                        }
                        .listStyle(.plain)
                        .refreshable {
                            await viewModel.fetchRepositories()
                        }
                    }
                }
            }
            .navigationTitle("Repos")
        }
    }
}

struct RepoRow: View {
    let repo: RepositoryResponse
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let avatarUrl = repo.owner?.avatarUrl, let url = URL(string: avatarUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 44, height: 44)
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                            .foregroundColor(.secondary)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .foregroundColor(.secondary)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(repo.name ?? repo.fullName ?? "Unknown")
                    .font(.headline)
                if let desc = repo.description, !desc.isEmpty {
                    Text(desc)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                HStack(spacing: 12) {
                    Label("\(repo.stargazersCount ?? 0)", systemImage: "star.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    if let lang = repo.language, !lang.isEmpty {
                        Text(lang)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ContentView()
}
