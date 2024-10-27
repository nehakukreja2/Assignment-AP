//
//  ViewController.swift
//  APAssignment
//
//  Created by Neha Kukreja on 22/10/24.
//

import UIKit

class ViewController: UIViewController {

    private let viewModel = ViewModel(mediaService: MediaService())
    var isLoading = false
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        viewModel.getMediaPosts()
    }
}

private extension ViewController {
    
    func initialSetup() {
        viewModel.delegate = self
        setupNavigationBar()
        setupCollectionView()
    }
    
    func setupNavigationBar() {
        self.title = "Media"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 30/255, green: 0/255, blue: 42/255, alpha: 1.0)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setupCollectionView() {
        initialCollectionViewSetup()
        registerNib()
    }
    
    func initialCollectionViewSetup() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func registerNib() {
        let nib = UINib(nibName: "MediaCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "MediaCollectionViewCell")
        let loadingCellNib = UINib(nibName: "LoadingCell", bundle: nil)
        collectionView.register(loadingCellNib, forCellWithReuseIdentifier: "LoadingCell")
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.medias.count
        } else if section == 1 {
            return viewModel.medias.count < 100 ? 1 : 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCollectionViewCell", for: indexPath) as? MediaCollectionViewCell else { return UICollectionViewCell() }
            let representedIdentifier = viewModel.medias[indexPath.item].id
            cell.representedIdentifier = representedIdentifier
            cell.configure(with: viewModel.medias[indexPath.item], representedIdentifier: representedIdentifier)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath) as? LoadingCell else { return UICollectionViewCell() }
            cell.activityIndicator.startAnimating()
            return cell
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: (collectionView.frame.width / 3) - 4, height: 170)
        } else {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            if !isLoading && viewModel.medias.count < 100 {
                isLoading = true
                self.viewModel.loadMoreData()
            }
        }
    }
}

extension ViewController: MediaDelegate {
    
    func reloadCollectionView() {
        self.isLoading = false
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func hideCollectionViewIfNoMediaAvailable() {
        self.collectionView.isHidden = true
    }
}
