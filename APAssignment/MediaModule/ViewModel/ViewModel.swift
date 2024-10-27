//
//  ViewModel.swift
//  APAssignment
//
//  Created by Neha Kukreja on 22/10/24.
//

import Foundation

protocol MediaDelegate: AnyObject {
    func reloadCollectionView()
    func hideCollectionViewIfNoMediaAvailable()
}

class ViewModel {
    
    weak var delegate: MediaDelegate?
    private let mediaService: MediaService
    var medias: [Medias] = []
    private var currentOffset = 0
    private let limit = 20
    
    init(mediaService: MediaService) {
        self.mediaService = mediaService
    }
    
    func getMediaPosts() {
        loadMoreData()
    }
    
    func loadMoreData() {
        mediaService.fetchMedia(offset: currentOffset, limit: limit) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let posts):
                self.medias.append(contentsOf: posts)
                self.currentOffset += posts.count
                self.delegate?.reloadCollectionView()
            case .failure(let error):
                print(error.localizedDescription)
                self.delegate?.hideCollectionViewIfNoMediaAvailable()
            }
        }
    }
}
