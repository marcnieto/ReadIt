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

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!

    // MARK: - UICollectionViewCell

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

    }

    fileprivate func bounceUp() {

    }

    // MARK: - Static

    static let kDefaultHeight: CGFloat = 322.0
    static let kDefaultTitleLabelHeight: CGFloat = 21.0

    static func height(forTitle title: String) -> CGFloat {
        let width = UIScreen.main.bounds.width / 2.0

        let string = title as NSString
        if let font = UIFont(name: "HelveticaNeue-Regular", size: 16.0) {
            let attributes: [NSAttributedStringKey: Any] = [.font: font]
            let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
            let rect = string.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
            let height = ceil(rect.size.height)

            return ListingCollectionViewCell.kDefaultHeight - ListingCollectionViewCell.kDefaultTitleLabelHeight + height
        }

        return kDefaultHeight
    }
}
