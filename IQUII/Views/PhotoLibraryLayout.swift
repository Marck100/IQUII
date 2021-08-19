//
//  PhotoLibraryLayout.swift
//  IQUII
//
//  Created by Marco Pilloni on 17/08/21.
//  Copyright © 2021 Marco Pilloni. All rights reserved.
//

import UIKit

class PhotoLibraryLayout: UICollectionViewLayout {

    private let numberOfColumns: Int = {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 3
        } else {
            return 2
        }
    }()
    
    private let cellPadding: CGFloat = 12
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = self.collectionView else { return 0 }
    
        let insets = collectionView.contentInset
        
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = self.collectionView else { return }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        let xOffset: [CGFloat] = {
            var offset: [CGFloat] = []
            for column in 0..<numberOfColumns {
                offset.append(CGFloat(column) * columnWidth)
            }
            
            return offset
        }()
        
        var column: Int = 0
        var yOffset: [CGFloat] = {
            var offset: [CGFloat] = []
            for column in 0..<numberOfColumns {
                offset.append(CGFloat(column % 2) * 80)
            }
            
            return offset
        }()
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let photoHeight: CGFloat = 220
            
            let height: CGFloat = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ?  column + 1 : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        
        self.contentHeight = 0
        self.cache = []
        
    }
    
}
