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
import FirebaseStorage

class PostsViewModel{
   
    var auth: Auth
    let firestore: Firestore
    let reference:StorageReference
    let router:Router
    init(controller:UIViewController){
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        self.reference = Storage.storage().reference()
        self.router = Router(controller: controller)
    }
    func saveImage(selectedImage:UIImageView,description:String,completion:@escaping(UIAlertController) -> Void) {
        let imagens = self.reference.child("Imagens")
        let imagensPost = imagens.child("posts")
        let  idImagem = NSUUID().uuidString
        if let selectedImage = selectedImage.image {
            if let dataImage = selectedImage.jpegData(compressionQuality: 0.5) {
                let uploadImage = imagensPost.child("\(idImagem).jpg")
                uploadImage.putData(dataImage, metadata: nil)  { (metaData,error) in
                    if (error == nil) {
                        uploadImage.downloadURL(completion: { (url, error) in
                            if (error == nil) {
                                if let downloadUrl = url {
                                    let downloadString = downloadUrl.absoluteString
                                    let post = PostModel(description: description, urlImage: downloadString,idImage: "\(idImagem).jpg")
                                    self.savePost(postInfo: post){ alert in
                                        completion(alert)
                                    }
                                }
                            } else {
                                let alert:AlertModel = AlertModel(mensagem: "Nada capturado", titulo: "confira a imagem selecionada")
                                completion(alert.makeAlert())
                            }
                        })
                        
                    }else{
                        let alert:AlertModel = AlertModel(mensagem: "Upload não realizado", titulo: "Error ao fazer o upload do Arquivo")
                        completion(alert.makeAlert())
                    }
                }
            }
        }
    }
    func savePost(postInfo:PostModel,completion:@escaping(UIAlertController) -> Void) {
        
        if let userLogged = auth.currentUser {
            let idUser = userLogged.uid
            self.firestore.collection("postagens")
                .document(idUser)
                .collection("postagens_usuario").addDocument(data: postInfo.makeDictonary() as [String : Any]) { (error) in
                    if (error == nil) {
                        let alert = AlertModel(mensagem: "Post realizado com sucesso", titulo: "Sucesso ao realizar a postagem").makeAlert()
                        let action = UIAlertAction(title: "voltar", style: .default) { UIAlertAction in
                            self.router.dimiss()
                        }
                        alert.addAction(action)
                        completion(alert)
                    } else {
                        let alert:AlertModel = AlertModel(mensagem: "Post não realizado", titulo: "Tente novamente mais tarde, ou entre em contato com o suporte e informe o seguinte codigo: \(String(describing: error))")
                        completion(alert.makeAlert())
                    }
                }
        }
    }
    func getPosts(completion:@escaping([Dictionary<String,Any>]) -> Void){
        var listOfPost:[Dictionary<String,Any>] = []
        if let idUserLogged = self.auth.currentUser?.uid {
            let id = idUserLogged
            self.firestore.collection("postagens")
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
   
    func getPostsForId(selectedUser:UserModel,completion:@escaping([PostModel]) -> Void ){
        var listOfPost:[PostModel] = []
        self.firestore.collection("postagens")
            .document(selectedUser.id)
            .collection("postagens_usuario")
            .getDocuments { (result,error) in
                if let snapshot = result {
                    for document in snapshot.documents{
                        if let dados = document.data()  as? NSDictionary {
                            let description = dados["descricao"] as! String
                            let url = dados["url"] as! String
                            let id = dados["idImage"] as! String
                            let post:PostModel = PostModel(description: description, urlImage: url, idImage: id)
                            listOfPost.append(post)
                        }
                    }
                    completion(listOfPost)
                }
            }
        
    }

}
