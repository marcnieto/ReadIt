//
//  TileCollectionViewLayout.swift
//  ReadIt
//
//  Created by Marc Nieto on 4/11/18.
//  Copyright © 2018 Marc Nieto. All rights reserved.
//
//  Inspired by PinterestView Layout by Ray Wenderlich
//

import UIKit

class TileCollectionViewLayout: UICollectionViewLayout {

    // MARK: - Accessing

    weak var delegate: UICollectionViewDelegateFlowLayout!

    fileprivate var numberOfColumns = 2
    fileprivate var cellPadding: CGFloat = ViewController.kInset

    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    fileprivate var contentHeight: CGFloat = 0.0

    fileprivate var contentWidth: CGFloat {
        guard let collectionView = self.collectionView else { return 0.0 }
        return collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
    }

    // MARK: - UICollectionViewLayout

    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.contentWidth, height: self.contentHeight)
    }

    override func prepare() {
        guard self.cache.isEmpty == true, let collectionView = self.collectionView else {
            return
        }

        let columnWidth = self.contentWidth / CGFloat(self.numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< self.numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: self.numberOfColumns)

        for item in 0 ..< collectionView.numberOfItems(inSection: ViewController.Sections.listings.rawValue) {
            let indexPath = IndexPath(item: item, section: ViewController.Sections.listings.rawValue)

            let height = delegate.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath).height ?? ListingCollectionViewCell.kDefaultHeight

            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: self.cellPadding, dy: self.cellPadding)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            self.cache.append(attributes)

            self.contentHeight = max(self.contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height

            column = column < (self.numberOfColumns - 1) ? (column + 1) : 0
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        for attributes in self.cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cache[indexPath.item]
    }

}
