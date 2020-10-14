//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by Ali Atakan AKMAN on 12.10.2020.
//

import UIKit
import Firebase

class FeedVC: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    
    

    @IBOutlet weak var tableView: UITableView!
    
    
    

    let fireStoreDatabase = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    getUserInfo()
    
    
    }
    
    func gerSnapsFromFirebase() {
        
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            
            if error != nil {
                self.makeAlert(title: "Error", msssage: error?.localizedDescription ?? "Error")
            }else{
                if snapshot?.isEmpty == false &&  snapshot != nil {
                    for document in snapshot!.documents {
                        
                        
                        
                        
                        
                        
                        
                    }
                }
            }
            
        }
        
    }
    
    
    func makeAlert(title : String , msssage : String) {
        let alert = UIAlertController(title: title, message: msssage, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
        


    func getUserInfo() {
        
        fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot, error) in
            if error  != nil {
                self.makeAlert(title: "Error", msssage: error?.localizedDescription ?? "Error")
                
            }else{
                
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents {
                        
                        if let username = document.get("username") as? String {
                            UserSingleton.sharedUserInfo.email = (Auth.auth().currentUser?.email)!
                            UserSingleton.sharedUserInfo.username = username
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell
        
        cell.feedUsernameLabel.text = "Test"
        
        return cell
        
        
    }
    
}
