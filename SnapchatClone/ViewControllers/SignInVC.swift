//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Beyza Nur Tekerek on 23.09.2024.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func signInClicked(_ sender: Any) {
        
        if passwordTextField.text != "" && emailTextField.text != "" {
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                
                if error != nil {
                    
                    self.makeAlert(title: "error!", message: error?.localizedDescription ?? "Error")
                    
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
                
            }
        } else {
            self.makeAlert(title: "error!", message: "email/password ?")
        }
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if userNameTextField.text != "" && passwordTextField.text != "" && emailTextField.text != "" {
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (auth, error) in
                
                if error != nil {
                    
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error")
                    
                } else {
                    
                    let fireStore = Firestore.firestore()
                    let userDictionary = ["username": self.userNameTextField.text!, "email": self.emailTextField.text!] as [String : Any]
                    fireStore.collection("UserInfo").addDocument(data: userDictionary) { (error) in
                        if error != nil {
                            //
                        }
                    }
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            self.makeAlert(title: "Error!", message: "username/email/password is wrong!")
        }
        
    }
    
    func makeAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
}

