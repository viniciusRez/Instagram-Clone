//
//  MakePostViewController.swift
//  Instagram Clone
//
//  Created by Vinicius Rezende on 18/01/23.
//

import UIKit

class MakePostViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var imagePicker:UIImagePickerController!
    var makePostViewModel:MakePostViewModel!
    var infoPost:PostModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        
        self.makePostViewModel = MakePostViewModel()
        // Do any additional setup after loading the view.
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
        self.savePost.setTitle("loading...", for: .normal)
        self.makePostViewModel.saveImage(selectedImage: self.imageview, description: self.descricao.text!) { alert in
            alert.returnToControll(controller: self)
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
