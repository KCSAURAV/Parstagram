//
//  LoginVC.swift
//  Parstagram
//
//  Created by SAURAV on 3/20/19.
//  Copyright © 2019 SAURAV. All rights reserved.
//

import UIKit
import Parse

class LoginVC: UIViewController, UITextFieldDelegate {

  @IBOutlet weak var username: UITextField!
  
  @IBOutlet weak var password: UITextField!
  
  @IBAction func signIn(_ sender: Any) {
    let user = username.text!
    let pass = password.text!
    PFUser.logInWithUsername(inBackground: user, password: pass){
      (user,error) in
      if user != nil {
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
      } else{
        print("Error: \(String(describing: error?.localizedDescription))" )
      }
    }
  }
  
  @IBAction func signUp(_ sender: Any) {
    
    var user = PFUser()
    user.username = username.text
    user.password = password.text
    user.signUpInBackground { (success, error) in
      if success {
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
      } else{
        print("Error: \(String(describing: error?.localizedDescription))" )
      }
      
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    username.delegate = self
    password.delegate = self
  }
  
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
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
