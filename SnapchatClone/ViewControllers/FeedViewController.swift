//
//  FeedViewController.swift
//  SnapchatClone
//
//  Created by Beyza Nur Tekerek on 23.09.2024.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let fireStoreDatabase = Firestore.firestore()
    var snapArray = [Snap]()
    var chosenSnap : Snap?
    var timeLeft : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        getSnapsFromFirebase()
        getUserInfo()

    }
    
    func getSnapsFromFirebase() {
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.makeAlert(title: "error", message: error?.localizedDescription ?? "error")
            } else {
                
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        
                        let documentId = document.documentID
                        
                        if let username = document.get("snapOwner") as? String {
                            
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                
                                if let date = document.get("date") as? Timestamp {
                                    
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        
                                        if difference >= 24 {
                                            
                                            self.fireStoreDatabase.collection("Snaps").document(documentId).delete { (error) in
                                                
                                            }
                                            
                                        }
                                        
                                        // TIME LEFT >> SNAPVC
                                        
                                        self.timeLeft = 24 - difference
                                        
                                    }
                                    
                                    let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue())
                                    self.snapArray.append(snap)
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    self.tableView.reloadData()
                    
                }
                
            }
        }
    }
    
    func getUserInfo() {
        
        fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot, error) in
            if error != nil {
                self.makeAlert(title: "error", message: error?.localizedDescription ?? "error")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents {
                        if let username = document.get("username") as? String {
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
                        }
                    }
                }
            }
        }
        
    }
    
    
    func makeAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.feedUsernameLabel.text = snapArray[indexPath.row].username
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSnapVC" {
            
            let destinationVC = segue.destination as! SnapViewController
            destinationVC.selectedSnap = chosenSnap
            destinationVC.selectedTime = self.timeLeft
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
    
}
