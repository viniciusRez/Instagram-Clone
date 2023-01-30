//
//  UserModel.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 17/01/23.
//

import Foundation

struct UserModel {
    let id:String
    let email:String
    let nome:String
    init(id: String, email: String, nome: String) {
        self.id = id
        self.email = email
        self.nome = nome
    }
    func makeDictonary() -> Dictionary<String,Any?>{
        let dictonary:Dictionary<String,Any?> = [
            "email":self.email,
            "id":self.id,
            "nome":self.nome
        ]
        return dictonary
    }
}
