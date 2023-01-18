//
//  CollectionViewModel.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 18/01/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class CollectionViewModel{
    let selectedUser:Dictionary<String,Any>!
    init(selectedUser: Dictionary<String, Any>!) {
        self.selectedUser = selectedUser
    }

    func getPosts(completion:@escaping([Dictionary<String,Any>]) -> Void ){
        let auth = Auth.auth()
        let firestore = Firestore.firestore()
        var listOfPost:[Dictionary<String,Any>] = []
        firestore.collection("postagens")
            .document(self.selectedUser["id"] as! String)
            .collection("postagens_usuario")
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
}
