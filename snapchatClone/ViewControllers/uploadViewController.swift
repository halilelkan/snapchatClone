//
//  uploadViewController.swift
//  snapchatClone
//
//  Created by halil ibrahim Elkan on 6.07.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class uploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var uploadImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePic))
        uploadImageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func choosePic(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareActionButton(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let mediaFolder = storageRef.child("media")
        
        let firestoreDatabase = Firestore.firestore()
        var firestoreRef : DocumentReference? = nil
        
        
        
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            let imageRef = mediaFolder.child("\(uuid).jpg")
            
            imageRef.putData(data, metadata: nil) { metaData, error in
                
                if error != nil {
                    self.makeAlert(title: "Hata!", message: error?.localizedDescription ?? "Error!")
                } else {
                    
                    imageRef.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            //MARK: - bir kullanıcının paylaştığı tüm görsellerin aynı diziye kaydedilmesi
                            
                            
                            firestoreDatabase.collection("snaps").whereField("userName", isEqualTo: userSingleton.sharedUserInfo.userName).getDocuments { snapShot, error in
                                if error != nil {
                                    self.makeAlert(title: "Hata!", message: error?.localizedDescription ?? "Error!")
                                } else {
                                    
                                    if snapShot?.isEmpty == false && snapShot != nil {
                                        for document in snapShot!.documents{
                                            
                                            let documentId = document.documentID
                                            
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                imageUrlArray.append(imageUrl!)
                                                
                                                let newImageUrlArray = ["imageUrlArray" : imageUrlArray]
                                                
                                                firestoreDatabase.collection("snaps").document(documentId).setData(newImageUrlArray, merge: true) { error in
                                                    
                                                    if error == nil {
                                                        self.uploadImageView.image = UIImage(named: "Image")
                                                        self.tabBarController?.selectedIndex = 0
                                                        
                                                    }
                                                }
                                                
                                            }
                                            
                                            
                                        }
                                    } else {
                                        
                                        let snapDic = ["userName" : userSingleton.sharedUserInfo.userName, "date" : FieldValue.serverTimestamp(), "imageUrlArray" : [imageUrl!]] as! [String : Any]
                                        
                                        firestoreDatabase.collection("snaps").addDocument(data: snapDic) { error in
                                            if error != nil {
                                                self.makeAlert(title: "Hata!", message: error?.localizedDescription ?? "Error!")
                                            } else {
                                                self.uploadImageView.image = UIImage(named: "Image")
                                                self.tabBarController?.selectedIndex = 0
                                                
                                            }
                                        }
                                        
                                    }
                                    
                                }
                            }
                            
                            
                        }
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
}
