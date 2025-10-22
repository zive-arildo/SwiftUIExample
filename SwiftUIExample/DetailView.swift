//
//  DetailView.swift
//  SwiftUITraining
//
//  Created by Arildo Junior on 18/07/24.
//

import Foundation
import SwiftUI

struct DetailView: View {
    let repo: RepositoryResponse
    @Environment(\.openURL) private var openURL

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .center, spacing: 16) {
                    if let avatar = repo.owner?.avatarUrl, let url = URL(string: avatar) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 72, height: 72)
                            case .success(let image):
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 72, height: 72)
                                    .clipShape(Circle())
                            case .failure:
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 72, height: 72)
                                    .foregroundColor(.secondary)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 72, height: 72)
                            .foregroundColor(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text(repo.name ?? repo.fullName ?? "Unknown")
                            .font(.title2)
                            .fontWeight(.semibold)
                        if let login = repo.owner?.login {
                            Text(login)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()
                }

                if let desc = repo.description, !desc.isEmpty {
                    Text(desc)
                        .font(.body)
                }

                HStack(spacing: 16) {
                    Label("\(repo.stargazersCount ?? 0)", systemImage: "star.fill")
                    Label("\(repo.forks ?? 0)", systemImage: "tuningfork")
                    Label("\(repo.watchers ?? 0)", systemImage: "eye")

                    if let lang = repo.language, !lang.isEmpty {
                        Text(lang)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    Spacer()
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                if let html = repo.htmlUrl, let url = URL(string: html) {
                    Button(action: { openURL(url) }) {
                        HStack {
                            Image(systemName: "safari")
                            Text("Open in GitHub")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle(repo.name ?? repo.fullName ?? "Repository")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let owner = OwnerResponse(id: 1, login: "octocat", avatarUrl: "https://avatars.githubusercontent.com/u/583231?v=4")
        let repo = RepositoryResponse(id: 1, name: "Hello-World", fullName: "octocat/Hello-World", description: "This is your first repo", owner: owner, stargazersCount: 123, forks: 10, watchers: 50, language: "Swift", htmlUrl: "https://github.com/octocat/Hello-World")
        NavigationStack {
            DetailView(repo: repo)
        }
        .previewDevice("iPhone 14")
    }
}
