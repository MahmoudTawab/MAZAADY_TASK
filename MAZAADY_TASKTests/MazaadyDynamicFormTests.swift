//
//  MazaadyDynamicFormTests.swift
//  MAZAADY_TASKTests
//
//  Created by Mahmoud on 27/03/2025.
//

import XCTest
@testable import MAZAADY_TASK

class MazaadyDynamicFormTests: XCTestCase {
    
    // MARK: - Test Case 1: Category Model Validation
    func testCategoryModelCreation() {
        let imageData = ImageData(
            medium: "medium_url",
            thumbnail: "thumbnail_url",
            id: 1,
            customProperties: nil,
            placeHolder: PlaceHolder(
                smallNoBg: "small_no_bg",
                mediumBg: "medium_bg",
                smallBg: "small_bg"
            )
        )
        
        let category = Category(
            id: 1,
            name: "Electronics",
            slug: "electronics",
            parentId: nil,
            propertiesCount: 10,
            image: imageData,
            seoTags: ["tech", "gadgets"],
            isOther: false
        )
        
        XCTAssertEqual(category.id, 1)
        XCTAssertEqual(category.name, "Electronics")
        XCTAssertNil(category.parentId)
        XCTAssertEqual(category.seoTags, ["tech", "gadgets"])
        XCTAssertFalse(category.isOther)
    }
    
    // MARK: - Test Case 2: Category with Parent Relationship
    func testCategoryModelWithParent() {
        let imageData = ImageData(
            medium: "parent_medium_url",
            thumbnail: "parent_thumbnail_url",
            id: 2,
            customProperties: nil,
            placeHolder: PlaceHolder(
                smallNoBg: "parent_small_no_bg",
                mediumBg: "parent_medium_bg",
                smallBg: "parent_small_bg"
            )
        )
        
        let category = Category(
            id: 2,
            name: "Smartphones",
            slug: "smartphones",
            parentId: 1, // Parent category
            propertiesCount: 5,
            image: imageData,
            seoTags: ["mobile", "tech"],
            isOther: false
        )
        
        XCTAssertEqual(category.parentId, 1)
        XCTAssertEqual(category.name, "Smartphones")
        XCTAssertEqual(category.propertiesCount, 5)
    }
    
    // MARK: - Test Case 3: Property Selection Logic
    func testPropertySelectionLogic() {
        let option = PropertyOption(id: 1, name: "Apple", hasChildren: false)
        
        let property = Property(
            id: 1,
            name: "Brand",
            description: "Select a brand",
            type: "select",
            parentId: nil,
            options: [option]
        )
        
        let selectedValue = SelectedValue(
            property: property,
            option: option,
            otherValue: nil
        )
        
        XCTAssertEqual(selectedValue.displayName, "Apple")
        XCTAssertEqual(selectedValue.property.name, "Brand")
    }
    
    // MARK: - Test Case 4: Property Without Options
    func testPropertyWithoutOptions() {
        let property = Property(
            id: 99,
            name: "Custom Property",
            description: "A property without options",
            type: "text",
            parentId: nil,
            options: nil
        )
        
        XCTAssertNil(property.options)
        XCTAssertEqual(property.type, "text")
        XCTAssertEqual(property.name, "Custom Property")
    }
    
    // MARK: - Test Case 5: Selected Value Scenarios
    func testSelectedValueErrorScenarios() {
        let property = Property(
            id: 1,
            name: "Test Property",
            description: nil,
            type: "select",
            parentId: nil,
            options: []
        )
        
        // Test with no option and no other value
        let emptySelectedValue = SelectedValue(
            property: property,
            option: nil,
            otherValue: nil
        )
        XCTAssertEqual(emptySelectedValue.displayName, "Not selected")
        
        // Test with other value but no specific option
        let otherSelectedValue = SelectedValue(
            property: property,
            option: nil,
            otherValue: "Custom Value"
        )
        XCTAssertEqual(otherSelectedValue.displayName, "Other: Custom Value")
    }
    
    // MARK: - Test Case 6: Network Request Simulation
    func testNetworkRequestSimulation() {
        let expectation = self.expectation(description: "Categories Fetch")
        
        // Create a mock network request simulation
        func simulateNetworkRequest(completion: @escaping (Result<[MAZAADY_TASK.Category], Error>) -> Void) {
            // Simulate successful response
            let imageData = ImageData(
                medium: "test_url",
                thumbnail: "thumb_url",
                id: 1,
                customProperties: nil,
                placeHolder: PlaceHolder(
                    smallNoBg: "small",
                    mediumBg: "medium",
                    smallBg: "small_bg"
                )
            )
            
            let mockCategories = [
                Category(
                    id: 1,
                    name: "Electronics",
                    slug: "electronics",
                    parentId: nil,
                    propertiesCount: 5,
                    image: imageData,
                    seoTags: ["tech"],
                    isOther: false
                )
            ]
            
            completion(.success(mockCategories))
        }
        
        simulateNetworkRequest { result in
            switch result {
            case .success(let categories):
                XCTAssertFalse(categories.isEmpty)
                XCTAssertEqual(categories.first?.name, "Electronics")
                XCTAssertEqual(categories.first?.seoTags, ["tech"])
            case .failure:
                XCTFail("Network request should succeed")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("Expectation failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Test Case 7: API Service Error Handling
    func testAPIServiceErrorHandling() {
        let expectation = self.expectation(description: "API Error Handling")
        
        // Mock a scenario where API fails
        func simulateFailedNetworkRequest(completion: @escaping (Result<[MAZAADY_TASK.Category], Error>) -> Void) {
            let mockError = NSError(
                domain: "TestErrorDomain",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Simulated network error"]
            )
            completion(.failure(mockError))
        }
        
        simulateFailedNetworkRequest { result in
            switch result {
            case .success:
                XCTFail("Request should fail")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Simulated network error")
                XCTAssertEqual((error as NSError).domain, "TestErrorDomain")
                XCTAssertEqual((error as NSError).code, -1)
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
