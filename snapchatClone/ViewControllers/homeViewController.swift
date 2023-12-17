//
//  homeViewController.swift
//  snapchatClone
//
//  Created by halil ibrahim Elkan on 6.07.2023.
//

import UIKit
import Firebase
import SDWebImage

class homeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let firestoreDatabase = Firestore.firestore()
    var snapArray = [Snap]()
    var choosenSnap : Snap?
    
    @IBOutlet weak var feedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTableView.delegate = self
        feedTableView.dataSource = self

        getUserInfo()
        fetchSnaps()
        
    }
    
    func fetchSnaps(){
        firestoreDatabase.collection("snaps").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                self.makeAlert(title: "Hata!", message: error?.localizedDescription ?? "Error!")
            } else{
                
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    self.snapArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        let documentId = document.documentID
                        
                        if let userName = document.get("userName") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                if let date = document.get("date") as? Timestamp {
                                    
                                    if let differance = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour{
                                        
                                        if differance >= 24 {
                                            self.firestoreDatabase.collection("snaps").document(documentId).delete()
                                        } else{
                                            let snap = Snap(userName: userName, imageUrlArray: imageUrlArray, date: date.dateValue(), timeLeft: 24 - differance)
                                            self.snapArray.append(snap)
                                        }
                                        
                                    }
                                    
                                }
                            }
                        }
                        
                    }
                    self.feedTableView.reloadData()
                }
                
            }
        }
    }
    
    func getUserInfo(){
        firestoreDatabase.collection("userInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email).getDocuments { snapshot, error in
            
            if error != nil{
                self.makeAlert(title: "Hata!", message: error?.localizedDescription ?? "Error!")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents {
                        
                        if let userName = document.get("userName") as? String {
                            userSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            userSingleton.sharedUserInfo.userName = userName
                        }
                    }
                }
            }
        }
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        
        cell.snapUserNameLabel.text = snapArray[indexPath.row].userName
        cell.snapImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC" {
            
            let destinationVC = segue.destination as! snapViewController
            
            destinationVC.selectedSnap = choosenSnap
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentUser = Auth.auth().currentUser
        if currentUser != nil {
            choosenSnap = self.snapArray[indexPath.row]
            performSegue(withIdentifier: "toSnapVC", sender: nil)
        }
    }
}
