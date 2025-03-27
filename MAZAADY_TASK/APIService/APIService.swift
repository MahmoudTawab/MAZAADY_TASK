//
//  APIService.swift
//  MAZAADY_TASK
//
//  Created by Mohamed Tawab on 26/03/2025.
//

import UIKit

// MARK: - API Service
/// A singleton class responsible for handling API requests.
class APIService {
    
    // Singleton instance
    static let shared = APIService()
    
    // Base URL for the API
    private let baseURL = "https://stagingapi.mazaady.com/api/v1"
    
    // Default headers for API requests
    private let headers: [String: String] = [
        "content-language": "en",
        "Accept": "application/json",
        "private-key": "Tg$LXgp7uK!D@aAj^aT3TmWY9a9u#qh5g&xgEETJ",
        "platform": "iOS",
        "currency": "AED"
    ]
    
    // Private initializer to prevent external instantiation
    private init() {}

    // MARK: - API Methods
    
    /// Fetches all categories from the API.
    /// - Parameter completion: A completion handler returning an array of `Category` or an `Error`.
    func getAllCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        let url = "\(baseURL)/all-categories/web"
        
        fetchData(from: url) { (result: Result<CategoriesResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.data.categories))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Fetches properties for a given category ID.
    /// - Parameters:
    ///   - categoryId: The ID of the category.
    ///   - completion: A completion handler returning an array of `Property` or an `Error`.
    func getProperties(for categoryId: Int, completion: @escaping (Result<[Property], Error>) -> Void) {
        let url = "\(baseURL)/properties/\(categoryId)"
        
        fetchData(from: url) { (result: Result<PropertiesResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Fetches option properties for a given option ID.
    /// - Parameters:
    ///   - optionId: The ID of the option.
    ///   - completion: A completion handler returning an array of `Property` or an `Error`.
    func getOptionProperties(for optionId: Int, completion: @escaping (Result<[Property], Error>) -> Void) {
        let url = "\(baseURL)/option-properties/\(optionId)"
        
        fetchData(from: url) { (result: Result<OptionPropertiesResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private Helper Method
    
    /// Fetches data from the given URL and decodes it into the specified generic type.
    /// - Parameters:
    ///   - url: The API endpoint URL.
    ///   - completion: A completion handler returning a decoded object or an `Error`.
    private func fetchData<T: Decodable>(from url: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else {
            let error = NSError(domain: "APIService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add headers to the request
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        // Execute the API request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "APIService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            // Print received JSON data for debugging purposes
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedObject))
                }
            } catch {
                print("Decoding error: \(error)")
                print("JSON data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
