//
//  AppNetworking.swift
//  APAssignment
//
//  Created by Neha Kukreja on 22/10/24.
//

import Foundation

class AppNetworking {
    
    static let shared = AppNetworking()
    
    private init() {}
    
    func fetchData<T: Decodable>(from request: URLRequest, completion: @escaping (Result<[T], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error while fetching data:", error)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([T].self, from: data)
                completion(.success(decodedData))
            } catch let jsonError {
                print("Failed to decode JSON:", jsonError)
                completion(.failure(jsonError))
            }
        }
        
        task.resume()
    }
}
