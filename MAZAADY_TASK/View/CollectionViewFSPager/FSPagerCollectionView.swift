//
//  FSPagerCollectionView.swift
//  MAZAADY_TASK
//
//  Created by Mohamed Tawab on 26/03/2025.
//

import UIKit

class FSPagerCollectionView: UICollectionView {
    
    #if !os(tvOS)
    override var scrollsToTop: Bool {
        set {
            super.scrollsToTop = false
        }
        get {
            return false
        }
    }
    #endif
    

    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    fileprivate func commonInit() {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        if #available(iOS 10.0, *) {
            self.isPrefetchingEnabled = false
        }
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        #if !os(tvOS)
            self.scrollsToTop = false
            self.isPagingEnabled = false
        #endif
    }
    
    
    var ContentInsetLeft: CGFloat = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentInset.left = ContentInsetLeft
    }
}
