//
//  PhotoLibraryViewController.swift
//  IQUII
//
//  Created by Marco Pilloni on 11/08/21.
//  Copyright © 2021 Marco Pilloni. All rights reserved.
//

import UIKit

class PhotoLibraryViewController: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            
            collectionView.register(UINib(nibName: "PhotoLibraryItem", bundle: nil), forCellWithReuseIdentifier: "photoCell")
        }
    }
    
    //MARK: Property
    lazy var redditController: RedditController = {
        let controller = RedditController.default
        return controller
    }()
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        
        return searchBar
    }()
    
    var posts: [Post] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView = searchBar
        // Do any additional setup after loading the view.
    }
    

    //MARK: Method
    
    //MARK: IBAction

}

//MARK:- UICollectionViewDataSource
extension PhotoLibraryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let post = posts[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoLibraryItem
        cell.post = post
        
        return cell
    }
    
}

//MARK:- UICollectionViewDelegateFlowLayout
extension PhotoLibraryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 20
        
        let collectionViewWidth = collectionView.frame.width
        let availableWidth = collectionViewWidth - ( spacing * 3 )
        
        let width = availableWidth/2
    
        return CGSize(width: width, height: width)
    }
    
}
//MARK:- UICollectionViewDelegate
extension PhotoLibraryViewController: UICollectionViewDelegate {
    
}

//MARK:- UISearchBarDelegate
extension PhotoLibraryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        
        redditController.fetchPosts(keyword) { (posts) in
            guard let posts = posts else { return }
            
            DispatchQueue.main.async {
                self.posts = posts
            }
        }
    }
    
}
