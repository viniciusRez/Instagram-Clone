//
//  UserViewModel.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 18/01/23.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class UserViewModel{
    let controller: UIViewController
    init(controller: UIViewController) {
        self.controller = controller
    }
    func getPosts(completion:@escaping([Dictionary<String,Any>]) -> Void){
        let firestore = Firestore.firestore()
        var listOfPost:[Dictionary<String,Any>] = []
            firestore.collection("usuarios")
                .getDocuments { (result,error) in
                    if let snapshot = result {
                        for document in snapshot.documents{
                            let dados = document.data()
                            listOfPost.append(dados)
                        }
                        completion(listOfPost)
                    }
                }
    }
    func searchUser(text:String,completion:@escaping([Dictionary<String,Any>]) -> Void){
        var itemFilter:[Dictionary<String,Any>] = []
        self.getPosts { result in
            for item in result {
                if let nome = item["nome"] as? String {
                    if nome.contains(text){
                        itemFilter.append(item)
                    }
                }
            }
            completion(itemFilter)
        }
    }
    func router(identifier:String,sender:Any?){
        self.controller.performSegue(withIdentifier: identifier, sender: sender)
    }

}
