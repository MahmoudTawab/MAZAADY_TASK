//
//  Property.swift
//  MAZAADY_TASK
//
//  Created by Mohamed Tawab on 26/03/2025.
//

import Foundation

// MARK: - Property Models
struct PropertiesResponse: Codable {
    let message: Message
    let data: [Property]
}

struct Property: Codable {
    let id: Int
    let name: String
    let description: String?
    let type: String
    let parentId: Int?
    let options: [PropertyOption]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, type
        case parentId = "parent_id"
        case options
    }
}

struct PropertyOption: Codable {
    let id: Int
    let name: String
    let hasChildren: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case hasChildren = "has_child"
    }
}

// MARK: - Selected Value
struct SelectedValue {
    let property: Property
    let option: PropertyOption?
    let otherValue: String?
    
    var displayName: String {
        if let option = option {
            return option.name
        } else if let otherValue = otherValue {
            return "Other: \(otherValue)"
        } else {
            return "Not selected"
        }
    }
}


struct OptionPropertiesResponse: Codable {
    let code: Int
    let msg: String
    let data: [Property]
}
