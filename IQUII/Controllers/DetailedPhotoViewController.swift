//
//  DetailedPhotoViewController.swift
//  IQUII
//
//  Created by Marco Pilloni on 17/08/21.
//  Copyright © 2021 Marco Pilloni. All rights reserved.
//

import UIKit

class DetailedPhotoViewController: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            
            collectionView.isPagingEnabled = true
            
            collectionView.dataSource = self
            collectionView.delegate = self
            
            collectionView.register(UINib(nibName: "DetailedPhotoItem", bundle: nil), forCellWithReuseIdentifier: "photoCell")
        }
    }
    
    //MARK: Property
    var posts: [Post] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var currentIndex: Int = 0
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Method
    
    //MARK: IBAction

}

//MARK:- UICollectionViewDataSource
extension DetailedPhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = posts[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! DetailedPhotoItem
        cell.post = post
        
        return cell
    }
    
}

//MARK:- UICollectionViewDelegate
extension DetailedPhotoViewController: UICollectionViewDelegate {
    
}

//MARK:- UICollectionViewDelegateFlowLayout
extension DetailedPhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
}
