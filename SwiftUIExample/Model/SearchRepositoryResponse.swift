//
//  SearchRepositoryResponse.swift
//  SwiftUITraining
//
//  Created by Arildo Junior on 18/07/24.
//

import Foundation

struct SearchRepositoryResponse: Codable {
	var totalCount: Int? = 0
	var incompleteResults: Bool? = false
	var items: [RepositoryResponse]?
    
    enum CodingKeys: String, CodingKey {
        case items
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
    }
}
