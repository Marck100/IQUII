//
//  PhotoLibraryItem.swift
//  IQUII
//
//  Created by Marco Pilloni on 11/08/21.
//  Copyright © 2021 Marco Pilloni. All rights reserved.
//

import UIKit

class PhotoLibraryItem: UICollectionViewCell {

    //MARK: IBOutlet
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 14
            imageView.contentMode = .scaleAspectFill
        }
    }
    
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
