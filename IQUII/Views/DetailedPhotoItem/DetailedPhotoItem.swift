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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: Property
    var post: Post!
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
        if let image = post.image {
            self.image = image
        } else {
            loadImage()
        }
    }
    
    private func loadImage() {
        DispatchQueue.global().async {
            guard
                let data = try? Data(contentsOf: self.post.imageURL),
                let image = UIImage(data: data)
            else { return }
            
            self.image = image
        }
    }
    
    //MARK: IBAction

}
