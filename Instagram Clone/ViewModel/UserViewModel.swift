//
//  LoginViewModel.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 17/01/23.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
class UserViewModel{
    var auth: Auth
    var firestore:Firestore
    init(){
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
    }
    func checkIsLogged(completion:@escaping(Bool) ->Void){
        self.auth.addStateDidChangeListener{ (auth,user) in
            print(user as Any)
            if user != nil{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    func singOut(){
        do{
            try self.auth.signOut()
        }catch{
            print(error)
        }
        
    }
    func login(email:String,senha:String,completion:@escaping(Bool,AlertModel) ->Void){
        var mensagem = ""
        var tittle = ""
        var notUser:Bool = false
        self.auth.signIn(withEmail: email, password: senha, completion: { (result, error) in
            if error == nil {
                if result == nil{
                    mensagem = "\(email) erro ao autenticar, tente novamente!!"
                    tittle = "Erro ao autenticar"
                }else{
                    mensagem = "\(email) seja bem vindo!!"
                    tittle = "Bem vindo"
                }
           
            } else {
                let erroR = error! as NSError
                print(erroR)
                notUser = true
                if let codigoError = erroR.userInfo["FIRAuthErrorUserInfoNameKey"]{
                    let mensagemError = codigoError as! String
                    print(mensagemError)
                    switch mensagemError{
                    case "ERROR_INVALID_EMAIL":
                        mensagem = " seu email e invalido!!"
                        tittle = "Email invalido"
                        break
                    case "ERROR_WRONG_PASSWORD":
                        mensagem = "Sua senha esta incorreta!!"
                        tittle = "Confira sua senha"
                        break
                    case "ERROR_USER_NOT_FOUND":
                        mensagem = "usuario não cadastrado!!"
                        tittle = "confira o email"
                        break
                    default:
                        mensagem = "\(email ) erro inesperado!!"
                        tittle = "Chame o suporte"
                    }
                }
            }

            let alert:AlertModel = AlertModel(mensagem:  mensagem, titulo: tittle)

            completion(notUser,alert)
        })
    
        
    }
    func register(email:String,senha:String,nome:String,completion:@escaping(Bool,AlertModel) ->Void) {
        var mensagem = ""
        var tittle = ""
        var errorRegister = false
        self.auth.createUser(withEmail: email, password: senha, completion: { (usuario, error) in
            if error == nil {
                if usuario != nil{
                    if let idUser = usuario?.user.uid{
                        let userData = UserModel(id: idUser, email: email, nome: nome)
                        self.firestore.collection("usuarios")
                            .document(idUser)
                            .setData(userData.makeDictonary() as [String : Any])
                        mensagem = "\(nome) olaa!!"
                        tittle = "Bem vindo"
                    }
                }
                
            } else {
                let erroR = error! as NSError
                print(erroR)
                errorRegister = true
                if let codigoError = erroR.userInfo["FIRAuthErrorUserInfoNameKey"]{
                    let mensagemError = codigoError as! String
                    print(mensagemError)
                    switch mensagemError{
                    case "ERROR_INVALID_EMAIL":
                        mensagem = "\(nome) seu email e invalido!!"
                        tittle = "Email invalido"
                        break
                    case "ERROR_WEAK_PASSWORD":
                        mensagem = "\(nome) sua senha esta fraca!!"
                        tittle = "Deixe sua senha forte"
                        break
                    case "ERROR_EMAIL_ALREADY_IN_USE":
                        mensagem = "\(nome) este email ja existe!!"
                        tittle = "Email ja cadastrado"
                        break
                        
                    default:
                        mensagem = "\(nome) erro inesperado!!"
                        tittle = "Chame o suporte"
                    }
                }
            }
            let alert:AlertModel = AlertModel(mensagem:  mensagem, titulo: tittle)
            
            completion(errorRegister,alert)
        })
    }
    
    func getUsers(completion:@escaping([UserModel]) -> Void){
        var listOfPost:[UserModel] = []
        self.firestore.collection("usuarios")
                .getDocuments { (result,error) in
                    if let snapshot = result {
                        for document in snapshot.documents{
                            if let dados = document.data()  as? NSDictionary {
                                let email = dados["email"] as! String
                                let nome = dados["nome"] as! String
                                let id = dados["id"] as! String
                                let user:UserModel = UserModel(id: id, email: email, nome: nome)
                                listOfPost.append(user)
                            }
                        }
                        completion(listOfPost)
                    }
                }
    }
    func searchUser(text:String,completion:@escaping([UserModel]) -> Void){
        var itemFilter:[UserModel] = []
        self.getUsers { result in
            for item in result {
                if let nome = item.nome  as? String {
                    if nome.contains(text){
                        itemFilter.append(item)
                    }
                }
            }
            completion(itemFilter)
        }
    }
}
