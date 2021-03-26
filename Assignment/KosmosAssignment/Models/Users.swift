//
//  Users.swift
//  KosmosAssignment
//
//  Created by Hitesh on 24/03/21.
//

import Foundation

struct UserPageData {
    var page : Int
    let perPage, total, totalPages: Int
}

// MARK: - UserData
struct UserData: Codable {
    let page, perPage, total, totalPages: Int
    let data: [User]
    let support: Support

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case data, support
    }
}

// MARK: - Datum
struct User: Codable {
    let id: Int?
    let email, firstName : String
    let lastName, avatar: String?

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
}

// MARK: - Support
struct Support: Codable {
    let url: String
    let text: String
}
