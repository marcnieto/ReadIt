//
//  LoadingCollectionViewCell.swift
//  ReadIt
//
//  Created by Marc Nieto on 4/11/18.
//  Copyright © 2018 Marc Nieto. All rights reserved.
//

import UIKit

class LoadingCollectionViewCell: UICollectionViewCell {

    // MARK: - Accessing

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var isLoading: Bool = false {
        didSet {
            _ = self.isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }

    static let reuseIdentifier = "loadingCollectionViewCell"

    // MARK: - UICollectionViewCell

    override func awakeFromNib() {
        super.awakeFromNib()

        self.activityIndicator.hidesWhenStopped = true
    }
}
