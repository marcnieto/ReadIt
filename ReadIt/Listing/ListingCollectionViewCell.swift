//
//  ListingCollectionViewCell.swift
//  ReadIt
//
//  Created by Marc Nieto on 4/10/18.
//  Copyright © 2018 Marc Nieto. All rights reserved.
//

import UIKit

class ListingCollectionViewCell: UICollectionViewCell {

    // MARK: - Accessing

    @IBOutlet weak var contents: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var isLoading: Bool = false {
        didSet {
            _ = self.isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }

    static let reuseIdentifier = "listingCollectionViewCell"

    // MARK: - UICollectionViewCell

    override func awakeFromNib() {
        super.awakeFromNib()

        self.activityIndicator.hidesWhenStopped = true
        self.backgroundColor = .clear
        self.contents.layer.cornerRadius = 5.0
        self.contents.layer.shadowRadius = 3.0
        self.contents.layer.shadowColor = UIColor.lightGray.cgColor
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.bounceDown()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.bounceUp()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.bounceUp()
    }

    // MARK: - Resize

    fileprivate func bounceDown() {
        UIView.animate(withDuration: 0.2, animations: {
            self.contents.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in

        }
    }

    fileprivate func bounceUp() {
        UIView.animate(withDuration: 0.2, animations: {
            self.contents.transform = CGAffineTransform.identity
        }) { _ in

        }
    }

    // MARK: - Static

    static let kDefaultHeight: CGFloat = 322.0
    static let kDefaultTitleLabelHeight: CGFloat = 21.0

    static func height(forTitle title: String) -> CGFloat {
        let width = UIScreen.main.bounds.width / 2.0

        let string = title as NSString
        let font = Font.medium.withSize(17.0)

        let attributes: [NSAttributedStringKey: Any] = [.font: font]
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let rect = string.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        let height = ceil(rect.size.height)

        return ListingCollectionViewCell.kDefaultHeight - ListingCollectionViewCell.kDefaultTitleLabelHeight + height
    }
}
