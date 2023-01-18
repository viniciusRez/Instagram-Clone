//
//  UsersViewController.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 17/01/23.
//

import UIKit

class UsersViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate{
    
    var listOfUsers:[Dictionary<String,Any>] = []
    var userViewMolde:UserViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userViewMolde = UserViewModel(controller: self)
        self.searchBarUser.delegate = self
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBarUser: UISearchBar!
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.userViewMolde.getPosts { result in
            self.listOfUsers = result
            self.tableView.reloadData()

        }
    }
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let textSearch = searchBar.text{
            if textSearch != ""{
                self.userViewMolde.searchUser(text: textSearch) { result in
                    self.listOfUsers = result
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listOfUsers.isEmpty
        {
            return 1
        }else{
            return listOfUsers.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUser", for: indexPath)

        if listOfUsers.isEmpty
        {   cell.textLabel!.text = "Nenhuma usuario encontrado."
        }else {
            let postagem = self.listOfUsers[indexPath.row]
            cell.textLabel!.text = postagem["nome"] as? String
            cell.detailTextLabel!.text = postagem["email"] as? String
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = self.listOfUsers[indexPath.row]
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.userViewMolde.router(identifier: "showPost", sender: selectedUser)
        
    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPost"{
            let viewdestination = segue.destination as!  PostsCollectionViewController
            viewdestination.selectedUser = sender as? Dictionary
        }
    }
}
