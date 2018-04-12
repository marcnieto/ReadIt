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

    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    
    static let reuseIdentifier = "listingCollectionViewCell"
    var imageHandler: ((UITouch, UIImage) -> Void)?
    var isLoaded: Bool = false

    var image: UIImage? {
        didSet {
            DispatchQueue.main.async {
                if let image = self.image {
                    self.thumbnailImageView.image = image
                }

            }
        }
    }

    var title: String? {
        didSet {
            if let title = self.title {
                self.titleLabel.text = title
            }
        }
    }

    var author: String? {
        didSet {
            if let author = self.author {
                self.authorLabel.text = author
            }
        }
    }

    var numberOfComments: Int = 0 {
        didSet {
            self.commentsLabel.text = "\(numberOfComments) comments"
        }
    }

    var date: String? {
        didSet {
            if let date = self.date {
                self.creationDateLabel.text = date
            }
        }
    }
    // MARK: - UICollectionViewCell

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = .clear
        self.contents.layer.masksToBounds = true
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
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            if self.thumbnailImageView.frame.contains(touchLocation) {
                self.imageHandler?(touch, self.thumbnailImageView.image!)
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.bounceUp()
    }

    // MARK: - Update
    

    // MARK: - Resize

    fileprivate func bounceDown() {
        UIView.animate(withDuration: 0.1, animations: {
            self.contents.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in

        }
    }

    fileprivate func bounceUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.contents.transform = CGAffineTransform.identity
        }) { _ in

        }
    }

    // MARK: - Static

    static let kDefaultHeight: CGFloat = 256.0
    static let kDefaultTitleLabelHeight: CGFloat = 18.0

    static func height(forTitle title: String, cellWidth: CGFloat) -> CGFloat {
        let kTitleLabelInset: CGFloat = 9.0
        let kVerticalPadding: CGFloat = ViewController.kInset
        let width = cellWidth - (2 * kTitleLabelInset)
        let string = title as NSString
        let font = Font.bold.withSize(15.0)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        print(width)

        let attributes: [NSAttributedStringKey: Any] = [.font: font, .paragraphStyle: paragraph]
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let rect = string.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        let height = ceil(rect.size.height)

        return ListingCollectionViewCell.kDefaultHeight - ListingCollectionViewCell.kDefaultTitleLabelHeight + (2*kVerticalPadding) + height
    }
}
