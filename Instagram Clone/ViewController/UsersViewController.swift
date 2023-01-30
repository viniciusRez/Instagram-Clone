//
//  UsersViewController.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 17/01/23.
//

import UIKit

class UsersViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate{
    
    var listOfUsers:[UserModel] = []
    var router: Router!
    var viewModel: UserViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = UserViewModel()
        self.router = Router(controller: self)
        self.searchBarUser.delegate = self
        
    }
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBarUser: UISearchBar!
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel.getUsers { result in
            self.listOfUsers = result
            self.tableView.reloadData()

        }
    }
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let textSearch = searchBar.text{
            if textSearch != ""{
                self.viewModel.searchUser(text: textSearch) { result in
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
            cell.textLabel!.text = postagem.nome
            cell.detailTextLabel!.text = postagem.email
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = self.listOfUsers[indexPath.row]
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.router.router(identifier: "showPost", sender: selectedUser)
        
    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPost"{
            let viewdestination = segue.destination as!  PostsCollectionViewController
            viewdestination.selectedUser = sender as? UserModel
        }
    }
}
