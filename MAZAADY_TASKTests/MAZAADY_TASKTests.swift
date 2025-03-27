//
//  MAZAADY_TASKTests.swift
//  MAZAADY_TASKTests
//
//  Created by Mahmoud on 26/03/2025.
//

import XCTest
@testable import MAZAADY_TASK

class MazaadyPortalTests: XCTestCase {
    
    // MARK: - Category Model Decoding Tests
    func testCategoryModelDecoding() {
        let jsonString = """
        {
            "id": 123,
            "name": "Electronics",
            "slug": "electronics",
            "parent_id": null,
            "properties_count": 10,
            "image": {
                "medium": "medium_url",
                "thumbnail": "thumbnail_url",
                "id": 456,
                "custom_properties": null,
                "place_holder": {
                    "small_no_bg": "small_no_bg_url",
                    "medium_bg": "medium_bg_url",
                    "small_bg": "small_bg_url"
                }
            },
            "seo_tags": ["electronics", "gadgets"],
            "is_other": false
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        do {
            let category = try JSONDecoder().decode(Category.self, from: jsonData)
            
            XCTAssertEqual(category.id, 123)
            XCTAssertEqual(category.name, "Electronics")
            XCTAssertEqual(category.slug, "electronics")
            XCTAssertNil(category.parentId)
            XCTAssertEqual(category.propertiesCount, 10)
            XCTAssertEqual(category.image.medium, "medium_url")
            XCTAssertEqual(category.seoTags, ["electronics", "gadgets"])
            XCTAssertFalse(category.isOther)
        } catch {
            XCTFail("Failed to decode Category: \(error)")
        }
    }
    
    // MARK: - Property Model Decoding Tests
    func testPropertyModelDecoding() {
        let jsonString = """
        {
            "id": 456,
            "name": "Brand",
            "description": "Choose a brand",
            "type": "select",
            "parent_id": null,
            "options": [
                {
                    "id": 789,
                    "name": "Apple",
                    "has_child": true
                }
            ]
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        do {
            let property = try JSONDecoder().decode(Property.self, from: jsonData)
            
            XCTAssertEqual(property.id, 456)
            XCTAssertEqual(property.name, "Brand")
            XCTAssertEqual(property.description, "Choose a brand")
            XCTAssertEqual(property.type, "select")
            XCTAssertNil(property.parentId)
            XCTAssertEqual(property.options?.count, 1)
            XCTAssertEqual(property.options?.first?.name, "Apple")
        } catch {
            XCTFail("Failed to decode Property: \(error)")
        }
    }
    
    // MARK: - Selected Value Display Name Tests
    func testSelectedValueDisplayName() {
        // Test with PropertyOption
        let option = PropertyOption(id: 123, name: "Samsung", hasChildren: false)
        let property = Property(
            id: 456,
            name: "Brand",
            description: nil,
            type: "select",
            parentId: nil,
            options: [option]
        )
        
        let selectedValueWithOption = SelectedValue(
            property: property,
            option: option,
            otherValue: nil
        )
        
        XCTAssertEqual(selectedValueWithOption.displayName, "Samsung")
        
        // Test with Other Value
        let selectedValueWithOther = SelectedValue(
            property: property,
            option: nil,
            otherValue: "Custom Brand"
        )
        
        XCTAssertEqual(selectedValueWithOther.displayName, "Other: Custom Brand")
        
        // Test with No Selection
        let selectedValueNoSelection = SelectedValue(
            property: property,
            option: nil,
            otherValue: nil
        )
        
        XCTAssertEqual(selectedValueNoSelection.displayName, "Not selected")
    }
    
    // MARK: - API Service Mock Tests
    func testAPIServiceCategoriesFetching() {
        let expectation = self.expectation(description: "Categories Fetch")
        
        APIService.shared.getAllCategories { result in
            switch result {
            case .success(let categories):
                XCTAssertFalse(categories.isEmpty, "Categories should not be empty")
                XCTAssertTrue(categories.allSatisfy { $0.id > 0 }, "All categories should have a valid ID")
            case .failure(let error):
                XCTFail("Failed to fetch categories: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Expectation failed: \(error.localizedDescription)")
            }
        }
    }
}
