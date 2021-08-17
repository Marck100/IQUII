//
//  DetailedPhotoItem.swift
//  IQUII
//
//  Created by Marco Pilloni on 17/08/21.
//  Copyright © 2021 Marco Pilloni. All rights reserved.
//

import UIKit

class DetailedPhotoItem: UICollectionViewCell {

    //MARK: IBOutlet
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 6.0
            scrollView.alwaysBounceVertical = false
            scrollView.alwaysBounceHorizontal = false
            
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: Property
    lazy var imageLoader: ImageLoader = {
        let loader = ImageLoader.shared
        return loader
    }()
    var post: Post! {
        didSet {
            updateUI()
        }
    }
    var image: UIImage! {
        didSet {
            DispatchQueue.main.async {
                self.imageView.image = self.image
                self.contentView.setNeedsLayout()
            }
        }
    }
    
    //MARK: View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: Method
    private func updateUI() {
        updateImage()
    }
    private func updateImage() {
        imageLoader.loadImage(from: post.imageURL) { (image) in
            self.image = image
        }
    }
    
    //MARK: IBAction

}


//MARK:- UIScrollViewDelegate
extension DetailedPhotoItem: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
