//
//  MakePostViewModel.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 18/01/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit
class MakePostViewModel{

    func saveImage(selectedImage:UIImageView,description:String,completion:@escaping(AlertModel) -> Void) {
        let storage = Storage.storage().reference()
        let imagens = storage.child("Imagens")
        let imagensPost = imagens.child("posts")
        let  idImagem = NSUUID().uuidString
        if let selectedImage = selectedImage.image {
            if let dataImage = selectedImage.jpegData(compressionQuality: 0.5){
                let uploadImage = imagensPost.child("\(idImagem).jpg")
                uploadImage.putData(dataImage, metadata: nil)  { (metaData,error) in
                    if error == nil{
                        let alert:AlertModel = AlertModel(mensagem: "Post realizado com sucesso", titulo: "Sucesso ao realizar a postagem")
                        uploadImage.downloadURL(completion: { (url, error) in
                            if error == nil {
                                if let downloadUrl = url {
                                    let downloadString = downloadUrl.absoluteString
                                    print("\(downloadString)")
                                    let post = PostModel(description: description, urlImage: downloadString,idImage: "\(idImagem).jpg")
                                    self.savePost(postInfo: post)
                                    completion(alert)
                                }
                            } else {
                                print("\(error!) Nada capturado")
                            }
                        })
                        
                    }else{
                        let alert:AlertModel = AlertModel(mensagem: "Upload não realizado", titulo: "Error ao fazer o upload do Arquivo")
                        completion(alert)
                    }
                }
            }
        }
    }
    func savePost(postInfo:PostModel){
        let firestore = Firestore.firestore()
        let auth = Auth.auth()
        if let userLogged = auth.currentUser{
            let idUser = userLogged.uid
            let postData = ["descricao":postInfo.description,"url":postInfo.urlImage]
            firestore.collection("postagens")
                .document(idUser)
                .collection("postagens_usuario").addDocument(data: postData) { (error) in
                    if error == nil{
                        
                    }else{
                        print(error)
                    }
                }
        }
    }
}
