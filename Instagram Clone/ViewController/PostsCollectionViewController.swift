//
//  PostsCollectionViewController.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 18/01/23.
//

import UIKit
import Kingfisher
private let reuseIdentifier = "Cell"

class PostsCollectionViewController: UICollectionViewController {
    var selectedUser:UserModel!
    var listOfPosts:[PostModel] = []
    var viewModel: PostsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PostsViewModel(controller: self)
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.reloadData()
        
    }
    func reloadData(){
        self.viewModel.getPostsForId(selectedUser: self.selectedUser) { result in
            self.listOfPosts = result
            self.collectionView.reloadData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
    }

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if listOfPosts.isEmpty {
            return 1
        } else {
            return listOfPosts.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyCollectionViewCell
        cell.load.startAnimating()
        
        if listOfPosts.isEmpty {
            cell.image.isHidden = true
            cell.descricao.text = "Nenhuma postagem realizada."
            cell.load.stopAnimating()
        } else {
            cell.image.isHidden = false
            let postagem = self.listOfPosts[indexPath.row]
            if let URL = URL(string: postagem.urlImage) {
                
                cell.image.setImageFromUrl(URL:URL)
                cell.load.stopAnimating()
                cell.descricao.text = postagem.description
            }
            
        }
        return cell
    }
    
}
