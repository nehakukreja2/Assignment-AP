//
//  ImageLoadManager.swift
//  APAssignment
//
//  Created by Neha Kukreja on 26/10/24.
//

import Foundation
import UIKit

class ImageLoader {
    
    static let shared = ImageLoader()
    private let cache = ImageCache.shared
    private var ongoingRequests: [URL: URLSessionDownloadTask]?
    
    private init() {}
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = url.absoluteString
        
        if let cachedImage = cache.getImage(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        if let ongoingReq = ongoingRequests?[url] {
            let existingTask = ongoingReq
            existingTask.cancel()
        }
        
        DispatchQueue.global(qos: .background).async {
            let task = URLSession.shared.downloadTask(with: url) { [weak self] fileURL, response, error in
                defer { self?.ongoingRequests?[url] = nil }
                
                guard let self = self, error == nil, let fileURL = fileURL else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                
                do {
                    let data = try Data(contentsOf: fileURL)
                    if let image = UIImage(data: data) {
                        self.cache.setImage(image, forKey: cacheKey)
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                } catch {
                    print("Error reading downloaded file: \(error)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
            task.resume()
            if var ongoingReq = self.ongoingRequests?[url] {
                ongoingReq = task
            }
        }
    }
    
    func cancelDownload(for url: URL) {
        ongoingRequests?[url]?.cancel()
        ongoingRequests?[url] = nil
    }
}
