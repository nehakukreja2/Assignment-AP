//
//  ImageCache.swift
//  APAssignment
//
//  Created by Neha Kukreja on 26/10/24.
//

import Foundation
import UIKit

class ImageCache {
    
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    private let diskCache = DiskCache.shared
    private init() {}
    
    func getImage(forKey key: String) -> UIImage? {
        if let memoryImage = cache.object(forKey: key as NSString) {
            return memoryImage
        }
        
        if let diskImage = diskCache.getImage(forKey: key) {
            cache.setObject(diskImage, forKey: key as NSString)
            return diskImage
        }
        
        return nil
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        diskCache.saveImage(image, forKey: key)
    }
    
    func removeImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        diskCache.removeImage(forKey: key)
    }
}
