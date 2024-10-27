//
//  MediaService.swift
//  APAssignment
//
//  Created by Neha Kukreja on 22/10/24.
//

import Foundation

class MediaService {
    
    private let baseURL = "https://acharyaprashant.org/api/v2/content/misc/media-coverages"
    
    func fetchMedia(offset: Int, limit: Int, completion: @escaping (Result<[Medias], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)?limit=\(limit)&offset=\(offset)") else {
            completion(.failure(NSError(domain: "URLError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let request = URLRequest(url: url)
        AppNetworking.shared.fetchData(from: request) { (result: Result<[Medias], Error>) in
            completion(result)
        }
    }
}
