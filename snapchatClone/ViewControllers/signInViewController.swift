//
//  ViewController.swift
//  snapchatClone
//
//  Created by halil ibrahim Elkan on 21.06.2023.
//

import UIKit
import Firebase

class signInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func signInActionButton(_ sender: Any) {
        
        if emailTextField.text != "" && userNameTextField.text != "" && passwordTextField.text != ""{
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { result, error in
                if error != nil {
                    self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Error")
                } else {
                    
                    self.performSegue(withIdentifier: "toHomeVC", sender: nil )
                }
            }
        } else {
            self.makeAlert(title: "Hata", message: "Lütfen Email ve Şifre'nin dolu olduğundan emin olunuz!")
        }
    }
    
    
    @IBAction func signUpActionButton(_ sender: Any) {
        
        if emailTextField.text != "" && userNameTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { auth, error in
                if error != nil {
                    self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Error ")
                } else {
                    
//     MARK: - kullanıcı adı kaydetme
                    
                    let userInfoDictionary = ["email" : self.emailTextField.text!, "userName" : self.userNameTextField.text!] as! [String : Any ]
                    let firestore = Firestore.firestore()
                    
                    firestore.collection("userInfo").addDocument(data: userInfoDictionary) { (error) in
                        if error != nil{
//                            self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Error")
                        }
                    }
                    
                    
//     MARK: - ana sayfaya geçiş
                    self.performSegue(withIdentifier: "toHomeVC", sender: nil )
                    
                }
            }
            
        } else {
            self.makeAlert(title: "Hata", message: "Lütfen Email, Kullanıcı Adı ve Şifre'nin dolu olduğundan emin olunuz!")
        }
        
    }

    
}

