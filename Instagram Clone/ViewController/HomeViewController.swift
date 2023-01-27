 //
//  HomeViewController.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 17/01/23.
//

import UIKit
import Kingfisher
class HomeViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
   
    var listOfPosts:[Dictionary<String,Any>] = []
    var homeViewModel:GetPostViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeViewModel = GetPostViewModel(controller: self)

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.reloadData()

    }
    func reloadData(){
        self.homeViewModel.getPosts { result in
            self.listOfPosts = result
            self.tableView.reloadData()
        }
    }
    @IBOutlet var tableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listOfPosts.isEmpty {
            return 1
        } else { 
            return listOfPosts.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellForPost", for: indexPath) as! MyCellTableViewCell
        cell.load.startAnimating()

        if listOfPosts.isEmpty
        {   cell.postImage.isHidden = true
            cell.descricao.text = "Nenhuma postagem realizada."
            cell.load.stopAnimating()
        }else{
            cell.postImage.isHidden = false

            let postagem = self.listOfPosts[indexPath.row]
            if let URL = URL(string: (postagem["url"] as! String)) {
                
                cell.postImage.setImageFromUrl(URL: URL)
                cell.load.stopAnimating()
                cell.descricao.text = postagem["descricao"] as? String
            }
            
        }
        return cell
    }
    
    @IBAction func makePost(_ sender: Any) {
        self.homeViewModel.router(identifier: "makepost", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImageView{
    
    func setImageFromUrl(URL:URL,mainQueue:DispatchQueue =  .main){
        mainQueue.async {
            self.kf.setImage(with: URL,completionHandler: {result in
               switch result {
               case .success:
                   print("Job OK")
               case .failure(let error):
                   print("Job failed: \(error.localizedDescription)")
               }
           })

        }
        
    }
}
