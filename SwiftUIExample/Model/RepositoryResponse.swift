//
//  RepositoryResponse.swift
//  SwiftUITraining
//
//  Created by Arildo Junior on 18/07/24.
//

import Foundation

struct RepositoryResponse: Codable, Identifiable {
	var id: Int
	var name: String? = ""
	var fullName: String? = ""
	var description: String? = ""
	var owner: OwnerResponse?
	var stargazersCount: Int? = 0
	var forks: Int? = 0
	var watchers: Int? = 0
	var language: String? = ""
	var htmlUrl: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case owner
        case forks
        case watchers
        case language
        case fullName = "full_name"
        case stargazersCount = "stargazers_count"
        case htmlUrl = "html_url"
    }
}
