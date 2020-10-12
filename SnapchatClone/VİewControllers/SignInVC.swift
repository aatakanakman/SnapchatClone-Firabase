//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Ali Atakan AKMAN on 12.10.2020.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailTextF: UITextField!
    @IBOutlet weak var usernameTextF: UITextField!
    @IBOutlet weak var passwordTextF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInClicked(_ sender: Any) {
        
        if passwordTextF.text != "" && emailTextF.text != "" {
            
            Auth.auth().signIn(withEmail: emailTextF.text!, password: passwordTextF.text!) { (result, error) in
                if error != nil{
                    self.makeAlert(title: "Error", msssage: error?.localizedDescription ?? "Error")
                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }else {
            self.makeAlert(title: "Error", msssage: "Password / Email ??")
        }
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if usernameTextF.text != "" && passwordTextF.text != "" && emailTextF.text != "" {
            
            Auth.auth().createUser(withEmail: emailTextF.text!, password: passwordTextF.text!) { (auth, error) in
                if error != nil {
                    self.makeAlert(title: "Error", msssage: error?.localizedDescription ?? "Error")
                }else{
                    
                    let fireStore = Firestore.firestore()
                    
                    let userDictionary = ["email" : self.emailTextF.text! , "username" : self.usernameTextF.text!] as [String:Any]
                    
                    fireStore.collection("UserInfo").addDocument(data: userDictionary) { (error) in
                        if error != nil {
                            //
                        }
                    }
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }else {
            self.makeAlert(title: "Error", msssage: "Username / Password / Email ??")
        }
    
    
    }
    
    func makeAlert(title : String , msssage : String) {
        let alert = UIAlertController(title: title, message: msssage, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    

}

