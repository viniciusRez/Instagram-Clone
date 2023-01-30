//
//  Router.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 27/01/23.
//

import Foundation
import UIKit
class Router{
    let controller: UIViewController
    init(controller: UIViewController) {
        self.controller = controller
    }
    func router(identifier:String,sender:Any?){
        self.controller.performSegue(withIdentifier: identifier, sender: sender)
    }
    func dimiss(){
        self.controller.navigationController?.popToRootViewController(animated: true)
        
    }
}

