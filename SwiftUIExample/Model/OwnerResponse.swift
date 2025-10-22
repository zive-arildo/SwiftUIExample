//
//  OwnerResponse.swift
//  SwiftUITraining
//
//  Created by Arildo Junior on 18/07/24.
//

import Foundation

struct OwnerResponse: Codable {
	var id: Int
	var login: String? = ""
	var avatarUrl: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
    }
}
