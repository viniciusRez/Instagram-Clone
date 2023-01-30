//
//  MakePostViewController.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 18/01/23.
//

import UIKit

class MakePostViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var imagePicker:UIImagePickerController!
    var infoPost:PostModel!
    var viewModel: PostsViewModel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PostsViewModel(controller: self)
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self

    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

    }
    @IBOutlet var imageview: UIImageView!
    @IBOutlet weak var descricao: UITextField!

    @IBAction func selectImage(_ sender: Any) {
        
        self.imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageRecover = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
      
              self.imageview.image = imageRecover
              self.imagePicker.dismiss(animated: true)
              self.enableButton(value: true)
    }
    func enableButton(value:Bool){
        if value{
            self.savePost.isEnabled = true
            

        }else{
            self.savePost.isEnabled = false
        }
    }
    @IBOutlet weak var savePost: UIButton!
    @IBAction func savePost(_ sender: Any) {
        
        print(self.imageview.image?.assetName as Any)
        if self.imageview.image?.assetName != "padrao" {
            self.savePost.setTitle("loading...", for: .normal)
            self.viewModel.saveImage(selectedImage: self.imageview, description: self.descricao.text!) { alert in
                self.present(alert, animated: true)
                
            }
        }else{
            let alert = AlertModel(mensagem: "Selecione uma imagem", titulo: "Imagem não selecionada")
            self.present(alert.makeAlert(), animated: true)

        }
    }
}
extension UIImage {

    var containingBundle: Bundle? {
        imageAsset?.value(forKey: "containingBundle") as? Bundle
    }

    var assetName: String? {
        imageAsset?.value(forKey: "assetName") as? String
    }

}
