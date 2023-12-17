//
//  Alert+Extension.swift
//  snapchatClone
//
//  Created by halil ibrahim Elkan on 9.07.2023.
//

import UIKit

extension UIViewController {
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

