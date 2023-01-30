//
//  ViewController.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 17/01/23.
//

import UIKit

class LoginViewController: UIViewController {
    var router: Router!
    var viewModel: UserViewModel!
    

    override func viewDidLoad() {
        self.router = Router(controller: self)
        self.viewModel = UserViewModel()

        self.viewModel.checkIsLogged(){ result in
            if result {
                self.router.router(identifier: "inside", sender: nil)
            }else{
                
            }
            
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
        self.viewModel.singOut()
        // Use data from the view controller which initiated the unwind segue
    }
    @IBOutlet var email: UITextField!
    @IBOutlet var senha: UITextField!
    @IBAction func logar(_ sender: Any) {
        if let email = self.email.text{
            if let senha = self.senha.text{
                
                self.viewModel.login(email:email,senha:senha, completion: {(result,alert) in
                   
                    self.present(alert.makeAlert(), animated: true)
                    
                })

            }
        }
    }
    
    @IBAction func register(_ sender: Any) {
        self.router.router(identifier: "register", sender: nil)
    }
    
}

