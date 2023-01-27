//
//  HomeViewModel.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 18/01/23.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class GetPostViewModel:Router{
  
    func getPosts(completion:@escaping([Dictionary<String,Any>]) -> Void){
        let firestore = Firestore.firestore()
        let auth = Auth.auth()
        var listOfPost:[Dictionary<String,Any>] = []
        if let idUserLogged = auth.currentUser?.uid {
            let id = idUserLogged
            firestore.collection("postagens")
                .document(id)
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
   
    func getPostsForId(selectedUser:Dictionary<String, Any>,completion:@escaping([Dictionary<String,Any>]) -> Void ){
        let auth = Auth.auth()
        let firestore = Firestore.firestore()
        var listOfPost:[Dictionary<String,Any>] = []
        firestore.collection("postagens")
            .document(selectedUser["id"] as! String)
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
