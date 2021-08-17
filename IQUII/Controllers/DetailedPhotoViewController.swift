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
    @IBOutlet weak var navBar: UINavigationBar!
    
    //MARK: Property
    var posts: [Post] = []
    
    var currentIndex: Int = 0
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: self.currentIndex, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        
    }
    
    //MARK: Method
    
    //MARK: IBAction
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x: CGFloat = {
            scrollView.contentOffset.x + scrollView.frame.width/2
        }()
        let y: CGFloat = {
            scrollView.frame.height/2
        }()
        let center = CGPoint(x: x, y: y)
        
        guard let indexPath = collectionView.indexPathForItem(at: center) else { return }
        let post = self.posts[indexPath.item]
        
        self.navBar.topItem?.title = post.author
    }
    
}

//MARK:- UICollectionViewDelegateFlowLayout
extension DetailedPhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = {
            view.frame.width
        }()
        let height: CGFloat = {
            view.frame.height - (view.safeAreaInsets.top + view.safeAreaInsets.bottom + navBar.frame.height)
        }()
        
        return CGSize(width: width, height: height)
    }
    
}
