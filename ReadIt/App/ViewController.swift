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

    var listings: [Listing]?
    var isLoading: Bool = false

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        self.isLoading = true
        SessionManager.shared.fetchTopListings { [weak self] listings in
            guard let strongSelf = self else { return }
            strongSelf.isLoading = false
            strongSelf.listings = listings
            strongSelf.collectionView.reloadData()
        }
    }
}

extension ViewController: UICollectionViewDataSource {

    enum Sections: Int {
        case listings = 0
        case loading = 1

        static let count = 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Sections(rawValue: section)! {
        case .listings:
            guard let listings = self.listings else { return 0 }
            return listings.count
        case .loading:
            return self.isLoading ? 1 : 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listingCollectionViewCell", for: indexPath) as! ListingCollectionViewCell
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate {
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .zero
    }
}
