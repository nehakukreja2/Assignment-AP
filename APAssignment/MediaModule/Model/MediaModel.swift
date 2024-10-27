//
//  MediaModel.swift
//  APAssignment
//
//  Created by Neha Kukreja on 22/10/24.
//

import Foundation

// MARK: - WelcomeElement
struct Medias: Codable {
    let id, title, language: String
    let thumbnail: Thumbnail
    let mediaType: Int
    let coverageURL: String
    let publishedAt, publishedBy: String
    let backupDetails: BackupDetails?
    let description, seoSlugWithID: String

    enum CodingKeys: String, CodingKey {
        case id, title, language, thumbnail, mediaType, coverageURL, publishedAt, publishedBy, backupDetails, description
        case seoSlugWithID = "seoSlugWithId"
    }
}

// MARK: - BackupDetails
struct BackupDetails: Codable {
    let pdfLink, screenshotURL: String
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let id: String
    let version: Int
    let domain: String
    let basePath, key: String
    let qualities: [Int]
    let aspectRatio: Double
}

extension Medias {
    func thumbnailURL() -> URL? {
        let imageURLString = "\(thumbnail.domain)/\(thumbnail.basePath)/0/\(thumbnail.key)"
        return URL(string: imageURLString)
    }
}
