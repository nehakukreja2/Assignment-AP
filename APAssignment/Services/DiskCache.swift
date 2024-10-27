//
//  DiskCache.swift
//  APAssignment
//
//  Created by Neha Kukreja on 26/10/24.
//

import Foundation
import UIKit

class DiskCache {
    
    static let shared = DiskCache()
    private init() {}
    
    private func diskCacheURL(forKey key: String) -> URL {
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let hashedKey = key.hashValue
        return cacheDirectory.appendingPathComponent("\(hashedKey).png")
    }
    
    func getImage(forKey key: String) -> UIImage? {
        let fileURL = diskCacheURL(forKey: key)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }
    
    func saveImage(_ image: UIImage, forKey key: String) {
        let fileURL = diskCacheURL(forKey: key)
        DispatchQueue.global(qos: .background).async {
            if let data = image.pngData() {
                try? data.write(to: fileURL)
            }
        }
    }
    
    func removeImage(forKey key: String) {
        let fileURL = diskCacheURL(forKey: key)
        try? FileManager.default.removeItem(at: fileURL)
    }
}
