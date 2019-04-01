//
//  CameraVC.swift
//  Parstagram
//
//  Created by SAURAV on 3/21/19.
//  Copyright © 2019 SAURAV. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class CameraVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate { // ImagePicker Controller inherits from UINavigation Controller

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var comment: UITextField!
  
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  @IBAction func onCamera(_ sender: Any) {
    let picker = UIImagePickerController()
    picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
    picker.allowsEditing = true
    
    if UIImagePickerController.isSourceTypeAvailable(.camera){ // enum Swift
      picker.sourceType = .camera
    } else{
      picker.sourceType = .photoLibrary
    }
    // allow camera button to choose from photo libtary
    present(picker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let image = info[.editedImage] as! UIImage
    let size = CGSize(width: 300, height: 300)
    let scaledImage = image.af_imageAspectScaled(toFill: size)// A bug in af_imageScaled(to: size)
    imageView.image = scaledImage
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func onSubmit(_ sender: Any) {
    let post = PFObject(className: "Posts") // schema
    post["caption"] = comment.text! // columns
    post["author"] = PFUser.current()!
    
    let imageData = imageView.image!.pngData()
    let file = PFFileObject(data: imageData!) // binary imagedata
    // ! unwrap
    post["image"] = file
    
    post.saveInBackground { (success, error) in
      if(success){
        self.dismiss(animated: true, completion: nil)
        print("Saved!")
      }
      else{ print("Error")}
    }
  }
  
}
