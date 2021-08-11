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
        }
    }
    
    //MARK: Property
    
    //MARK: View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: Method
    
    //MARK: IBAction

}
