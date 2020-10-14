//
//  UploadVC.swift
//  SnapchatClone
//
//  Created by Ali Atakan AKMAN on 12.10.2020.
//

import UIKit
import Firebase

class UploadVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var uploadImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        uploadImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        uploadImageView.addGestureRecognizer(gestureRecognizer)
        
        
    }
    
    @objc func choosePicture() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.originalImage] as?  UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func uploadClicked(_ sender: Any) {
        
        //STORAGE
    
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5) {
           
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Eroor" )
                    
                }else {
                    
                    imageReference.downloadURL { (url, error) in
                        
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            // FIRESTORE
                            
                            
                            let fireStore = Firestore.firestore()
                                                        
                            fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { (snapshot, error) in
                                if error != nil {
                                        self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                } else {
                                        if snapshot?.isEmpty == false && snapshot != nil {
                                            for document in snapshot!.documents {
                                                                        
                                                let documentId = document.documentID
                                                                        
                                                if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                    imageUrlArray.append(imageUrl!)
                                                   let additionalDictionary = ["imageUrlArray" : imageUrlArray] as [String : Any]
                                                   fireStore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { (error) in
                                                            if error == nil {
                                                                     self.tabBarController?.selectedIndex = 0
                                                             self.uploadImageView.image = UIImage(named: "selectimage.png")
                                                        }
                                                   }
                                                }
                                            }
                                     } else {
                                            let snapDictionary = ["imageUrlArray" : [imageUrl!], "snapOwner" : UserSingleton.sharedUserInfo.username,"date":FieldValue.serverTimestamp()] as [String : Any]
                                                                    
                                                fireStore.collection("Snaps").addDocument(data: snapDictionary) { (error) in
                                                if error != nil {
                                                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                                } else {
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.uploadImageView.image = UIImage(named: "selectimage.png")
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
                                
                                
  func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        }
    
}
