//
//  settingViewController.swift
//  snapchatClone
//
//  Created by halil ibrahim Elkan on 6.07.2023.
//

import UIKit
import Firebase

class settingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func logoutActionButton(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSignInVC", sender: nil )
            
        } catch {
            
        }
    }
    
}
