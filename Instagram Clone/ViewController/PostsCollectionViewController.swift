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
    var selectedUser:Dictionary<String,Any>!
    var listOfPosts:[Dictionary<String,Any>] = []
    var collectionViewModel:CollectionViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionViewModel = CollectionViewModel(selectedUser:self.selectedUser)
        self.reloadData()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.reloadData()
        
    }
   func reloadData(){
        self.collectionViewModel.getPosts { result in
            self.listOfPosts = result
            self.collectionView.reloadData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

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
            if let url = URL(string: (postagem["url"] as! String)) {
                
                cell.image.kf.setImage(with: url){result in
                    switch result {
                    case .success:
                        cell.load.stopAnimating()
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                }
                
                cell.descricao.text = postagem["descricao"] as? String
            }
            
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
