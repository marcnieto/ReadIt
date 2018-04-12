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

    var isInitialLoading: Bool = true
    static let kInset: CGFloat = 5.0
    let pageSize: Int = 15

    var listings: [Listing] = [] {
        didSet {
            if let collectionView = self.collectionView {
                if self.isInitialLoading {
                    DispatchQueue.main.async {
                        collectionView.reloadData()
                    }
                    self.isInitialLoading = false
                } else {

                    DispatchQueue.main.async {
                        collectionView.reloadData()
                    }

                }
            }
        }
    }

    var allListings: [Listing] = []

    var images = [Int: UIImage]()
    fileprivate var dimmingView: UIView!
    fileprivate var imageView: UIImageView!
    fileprivate var imageLocation: CGPoint = .zero

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.contentInset = UIEdgeInsets(top: 25.0, left: ViewController.kInset, bottom: 0.0, right: ViewController.kInset)

        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        if let layout = self.collectionView.collectionViewLayout as? TileCollectionViewLayout {
            layout.delegate = self
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        SessionManager.shared.fetchTopListings { [weak self] listings in
            guard let strongSelf = self else { return }

            guard let listings = listings else { return }
            strongSelf.allListings = listings
            strongSelf.listings = Array(strongSelf.allListings[0..<strongSelf.pageSize])
        }
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: - Actions

    fileprivate func showImage(_ image: UIImage, location: CGPoint) {
        let dimmingView = UIView(frame: self.view.bounds)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        dimmingView.alpha = 0.0

        let imageView = UIImageView(frame: CGRect(x: 20.0, y: 20.0, width: AppDelegate.shared.screenWidth - 40.0, height: AppDelegate.shared.screenHeight - 40.0))
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissImage(_:)))
        imageView.addGestureRecognizer(tapGesture)

        imageView.alpha = 0.3

        dimmingView.addSubview(imageView)
        self.view.addSubview(dimmingView)

        imageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        imageView.center = location

        UIView.animate(withDuration: 0.4) {
            imageView.transform = .identity
            imageView.alpha = 1.0
            dimmingView.alpha = 1.0
            imageView.center = self.view.center
        }

        self.dimmingView = dimmingView
        self.imageView = imageView
        self.imageLocation = location
    }

    @objc func dismissImage(_ sender: Any?) {
        let dimmingView = self.dimmingView!
        let imageView = self.imageView!
        let location = self.imageLocation

        UIView.animate(withDuration: 0.4, animations: {
            imageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            imageView.alpha = 0.3
            dimmingView.alpha = 0.0
            imageView.center = location
        }) { _ in
            self.dimmingView.removeFromSuperview()
            self.imageView.removeFromSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {

    enum Sections: Int {
        case listings = 0

        static let count = 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Sections(rawValue: section)! {
        case .listings:
            return self.listings.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Sections(rawValue: indexPath.section)! {
        case .listings:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListingCollectionViewCell.reuseIdentifier, for: indexPath) as! ListingCollectionViewCell

            let listing = self.listings[indexPath.row]

            cell.title = listing.data.title
            cell.author = listing.data.author
            cell.numberOfComments = listing.data.numberOfComments
            cell.date = listing.data.created

            cell.imageHandler = { [weak self] touch, image in
                guard let strongSelf = self else { return }
                let touchLocation = touch.location(in: strongSelf.view)
                strongSelf.showImage(image, location: touchLocation)
            }

            if let image = self.images[indexPath.row] {
                DispatchQueue.main.async {
                    cell.thumbnailImageView.image = image
                }
            } else {
                if UIApplication.shared.canOpenURL(URL(string: listing.data.thumbnail)!) {
                    SessionManager.shared.downloadImage(from: listing.data.thumbnail) { [weak self] image in
                        guard let image = image else { return }
                        guard let strongSelf = self else { return }

                        strongSelf.images[indexPath.row] = image

                        DispatchQueue.main.async {
                            cell.thumbnailImageView.image = image
                        }
                    }
                } else {
                    cell.thumbnailImageView.image = UIImage(named: "gray")
                    cell.imageHandler = nil
                }
            }
            
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 0.4
        animation.fromValue = 0.0
        animation.toValue = 1.0
        cell.layer.add(animation, forKey: "opacity")

        // Handles pagination
        let currentPage = Int(indexPath.row / self.pageSize)

        if indexPath.row % self.pageSize > (self.pageSize - 2) && self.listings.count == (currentPage * self.pageSize) + self.pageSize {
            let nextPage = currentPage + 1
            let frontIndex = min(self.pageSize * nextPage, self.allListings.count - 1)
            let endIndex = min((self.pageSize * nextPage) + self.pageSize, self.allListings.count - 1)

            guard frontIndex != endIndex else { return }

            let nextPageArray = Array(self.allListings[frontIndex..<endIndex])
            self.listings.append(contentsOf: nextPageArray)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch Sections(rawValue: indexPath.section)! {
        case .listings:
            let listing = self.listings[indexPath.row]
            let width = (AppDelegate.shared.screenWidth - (6 * ViewController.kInset)) / 2.0
            let height = ListingCollectionViewCell.height(forTitle: listing.data.title,
                                                          cellWidth: width)
            let size = CGSize(width: width, height: height)

            return size
        }
    }
}
