//
//  HeaderImageView.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 9.02.2024.
//

import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {

    let activeDistance: CGFloat = 200
    let zoomFactor: CGFloat = 0.3
    let minimumAlpha: CGFloat = 0.5

    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView, let attributes = super.layoutAttributesForElements(in: rect) else { return nil }

        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)

        for attribute in attributes {
            let distance = visibleRect.midX - attribute.center.x
            let normalizedDistance = distance / activeDistance
            let zoom = 1 + zoomFactor * (1 - abs(normalizedDistance))
            let alpha = 1 - abs(normalizedDistance) + minimumAlpha

            attribute.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
            attribute.alpha = alpha
        }

        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        let itemWidth = collectionView.bounds.width * 0.7
        let itemHeight = collectionView.bounds.height * 0.7

        itemSize = CGSize(width: itemWidth, height: itemHeight)
        minimumLineSpacing = collectionView.bounds.width * 0.1
        scrollDirection = .horizontal
    }
}
