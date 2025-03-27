//
//  CategoriesResponse.swift
//  MAZAADY_TASK
//
//  Created by Mohamed Tawab on 26/03/2025.
//

import Foundation

// MARK: - Category Model
struct CategoriesResponse: Codable {
    let message: Message
    let data: CategoryData
}

struct Message: Codable {
    let txt: [String?]
}


// MARK: - Categories Response
struct CategoryData: Codable {
    let categories: [Category]
    let iosVersion: String
    let iosLatestVersion: String
    let googleVersion: String
    let huaweiVersion: String
    
    enum CodingKeys: String, CodingKey {
        case categories
        case iosVersion = "ios_version"
        case iosLatestVersion = "ios_latest_version"
        case googleVersion = "google_version"
        case huaweiVersion = "huawei_version"
    }
}

struct Category: Codable {
    let id: Int
    let name: String
    let slug: String?
    let parentId: Int?
    let propertiesCount: Int
    let image: ImageData
    let seoTags: [String]
    let isOther: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case parentId = "parent_id"
        case propertiesCount = "properties_count"
        case image
        case seoTags = "seo_tags"
        case isOther = "is_other"
    }
}

struct ImageData: Codable {
    let medium: String
    let thumbnail: String
    let id: Int?
    let customProperties: String?
    let placeHolder: PlaceHolder
    
    enum CodingKeys: String, CodingKey {
        case medium, thumbnail, id
        case customProperties = "custom_properties"
        case placeHolder = "place_holder"
    }
}

struct PlaceHolder: Codable {
    let smallNoBg: String
    let mediumBg: String
    let smallBg: String
    
    enum CodingKeys: String, CodingKey {
        case smallNoBg = "small_no_bg"
        case mediumBg = "medium_bg"
        case smallBg = "small_bg"
    }
}

