//
//  postagemMODEL.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 17/01/23.
//

import Foundation

struct PostModel{
    var description:String
    var urlImage:String
    var idImage:String
    init(description: String, urlImage: String, idImage: String) {
        self.description = description
        self.urlImage = urlImage
        self.idImage = idImage
    }
}
