//
//  ViewController.swift
//  ReadIt
//
//  Created by Marc Nieto on 4/10/18.
//  Copyright © 2018 Marc Nieto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Accessing

    @IBOutlet weak var collectionView: UICollectionView!

    var listings: [Listing] = [] {
        didSet {
            if let collectionView = self.collectionView {
                DispatchQueue.main.sync {
                    collectionView.reloadData()
                }
            }
        }
    }
    var isLoading: Bool = false
    static let kInset: CGFloat = 5.0

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.contentInset = UIEdgeInsets(top: 0.0, left: ViewController.kInset, bottom: 0.0, right: ViewController.kInset)

        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        if let layout = self.collectionView.collectionViewLayout as? TileCollectionViewLayout {
            layout.delegate = self
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        self.isLoading = true
        SessionManager.shared.fetchTopListings { [weak self] listings in
            guard let strongSelf = self else { return }
            strongSelf.isLoading = false

            guard let listings = listings else { return }
            strongSelf.listings = listings
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {

    enum Sections: Int {
        case listings = 0
        case loading = 1

        static let count = 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Sections(rawValue: section)! {
        case .listings:
            return self.listings.count
        case .loading:
            return self.isLoading ? 1 : 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Sections(rawValue: indexPath.section)! {
        case .listings:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListingCollectionViewCell.reuseIdentifier, for: indexPath) as! ListingCollectionViewCell
            let listing = self.listings[indexPath.row]

            cell.titleLabel.text = listing.data.title
            return cell
        case .loading:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionViewCell.reuseIdentifier, for: indexPath) as! LoadingCollectionViewCell
            cell.isLoading = self.isLoading
            return cell
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch Sections(rawValue: indexPath.section)! {
        case .listings:
            let listing = self.listings[indexPath.row]
            let width = (AppDelegate.shared.screenWidth - (3 * ViewController.kInset)) / 2.0
            let height = ListingCollectionViewCell.height(forTitle: listing.data.title)

            return CGSize(width: width, height: height)
        case .loading:
            return CGSize(width: AppDelegate.shared.screenWidth, height: 100.0)
        }
    }
}
