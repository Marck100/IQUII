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
            collectionView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12)
            
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
            if posts.isEmpty {
                self.collectionView.backgroundView = emptyResultBackground()
            } else {
                self.collectionView.backgroundView = UIView()
            }
            collectionView.reloadData()
        }
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView = searchBar
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView.backgroundView = typeForSearchBackground()
    }
    
    override func viewDidLayoutSubviews() {
        self.collectionView.collectionViewLayout.invalidateLayout()
        
        if posts.count == 0 {
            if searchBar.text == "" {
                self.collectionView.backgroundView = typeForSearchBackground()
            } else {
                self.collectionView.backgroundView = emptyResultBackground()
            }
        }
        
    }
    

    //MARK: Method
    private func collectionViewBackground(image: UIImage, text: String) -> UIView {
        
        func addImageView(view: UIView, image: UIImage) -> UIImageView {
            let idiom = UIDevice.current.userInterfaceIdiom
            
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            
            view.addSubview(imageView)
            
            let xConstraint = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
            let yConstraint = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: -100)
            
            let widthConstant: CGFloat = idiom == .pad ? self.view.frame.width/2 : self.view.frame.width/1.5
            let widthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: widthConstant)
            let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.frame.height/2)
            
            NSLayoutConstraint.activate([xConstraint, yConstraint, widthConstraint, heightConstraint])
            
            return imageView
        }
        
        func addLabel(view: UIView, imageView: UIImageView, text: String) {
            
            let idiom = UIDevice.current.userInterfaceIdiom
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = NSLocalizedString(text, comment: "")
            label.textAlignment = .center
            label.textColor = .lightGray
            label.numberOfLines = 0
            label.font = idiom == . pad ? UIFont.systemFont(ofSize: 32) : UIFont.systemFont(ofSize: 17)
            
            let xConstraint = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
            
            let topConstant: CGFloat = idiom == .pad ? 20 : 8
            let topConstraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: topConstant)
            let leadingConstraint = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20)
            
            view.addSubview(label)
            
            NSLayoutConstraint.activate([xConstraint, topConstraint, leadingConstraint])
        }

        let view = UIView()
        view.frame = collectionView.bounds
        
        let imageView = addImageView(view: view, image: image)
        addLabel(view: view, imageView: imageView, text: text)
        
        return view
    }
    
    private func typeForSearchBackground() -> UIView {
        collectionViewBackground(image: #imageLiteral(resourceName: "search"), text: "Type something to start fetching photos")
    }
    
    private func emptyResultBackground() -> UIView {
        collectionViewBackground(image: #imageLiteral(resourceName: "no_data"), text: "We cannot find anything. Try with a different keyword.")
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "DetailedPhotoViewController") as! DetailedPhotoViewController
        vc.currentIndex = indexPath.item
        
        if vc.posts != self.posts {
            vc.posts = self.posts
        }
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        
        self.present(vc, animated: true, completion: nil)
    }
    
}

//MARK:- UISearchBarDelegate
extension PhotoLibraryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        guard let keyword = searchBar.text else { return }
        
        redditController.fetchPosts(keyword) { (posts) in
            
            DispatchQueue.main.async {
                self.posts = posts ?? []
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.posts = []
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
}
