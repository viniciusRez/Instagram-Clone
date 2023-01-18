//
//  RegisterViewController.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 17/01/23.
//

import UIKit

class RegisterViewController: UIViewController {
    var registerViewModel:RegisterViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerViewModel = RegisterViewModel()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBOutlet var nome: UITextField!
    @IBOutlet var senha: UITextField!
    @IBOutlet var email: UITextField!
    @IBAction func cadastrar(_ sender: Any) {
        if let nome = self.nome.text{
            if let email = self.email.text{
                if let senha = self.senha.text{
                    
                    self.registerViewModel.register(email:email,senha:senha,nome:nome, completion: {(result,alert) in
                        self.present(alert.makeAlert(), animated: true)
                    })

                }
            }
        }
    }
 
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
