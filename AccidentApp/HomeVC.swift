//
//  HomeVC.swift
//  AccidentApp
//
//  Created by Maryum Abdullah on 15/07/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class HomeVC: UIViewController {
    
    @IBOutlet weak var yourCarTF: UITextField!
    @IBOutlet weak var textVu: UITextView!
    @IBOutlet weak var reportedCarTF: UITextField!
    @IBOutlet weak var selectLocationBtn: UIButton!
    
    @IBOutlet weak var firstImg: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
//    @IBOutlet weak var thirdImage: UIImageView!
//    @IBOutlet weak var fourthImage: UIImageView!
    
    
    var ref = DatabaseReference.init()
    
    // Get a reference to the storage service using the default Firebase App
    let storage = Storage.storage()
    
    var imageURL = ""
    var videoURL = ""
    
    var firstImageSelected = false
    var secondImageSelected = false
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ref = Database.database().reference()
        
        
        self.textVu.text = "More Information ..."
        
        self.textVu.layer.cornerRadius = 5.0
        self.textVu.layer.borderColor = UIColor.black.cgColor
        self.textVu.layer.borderWidth = 1.5
    }
    
    func addClickListener() {
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(tappedFirstImage))
        firstImg.isUserInteractionEnabled = true
        firstImg.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(tappedSecondImage))
        secondImage.isUserInteractionEnabled = true
        secondImage.addGestureRecognizer(tapGesture2)
        
//        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(tappedThirdecondImage))
//        thirdImage.isUserInteractionEnabled = true
//        thirdImage.addGestureRecognizer(tapGesture3)
//
//        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(tappedFourthImage))
//        fourthImage.isUserInteractionEnabled = true
//        fourthImage.addGestureRecognizer(tapGesture4)
        
    }
    
    @objc func tappedFirstImage(sender: UITapGestureRecognizer){
        print(#function)
        print(sender.view?.tag as Any)
        
        firstImageSelected = true
        secondImageSelected = false
        
        uploadContent()
     }
    
    @objc func tappedSecondImage(sender: UITapGestureRecognizer){
        print(#function)
        print(sender.view?.tag as Any)
       
        secondImageSelected = true
        firstImageSelected = false
     }
    
//    @objc func tappedThirdecondImage(sender: UITapGestureRecognizer){
//        print(#function)
//        print(sender.view?.tag as Any)
//     }
//
//    @objc func tappedFourthImage(sender: UITapGestureRecognizer){
//        print(#function)
//        print(sender.view?.tag as Any)
//     }
    
    func uploadContent() {
        
        if firstImageSelected == true {
            uploadImage()
        } else {
            uploadVideo()
        }

    }
    
    func uploadVideo () {
        
    }
    
    func uploadImage() {
                
        // get current logged in user key
        let userId = Auth.auth().currentUser?.uid
        // Create a storage reference from our storage service
        let storageRef = storage.reference()

        self.imageURL = "image:\(userId!).png"
        let imagesRef = storageRef.child(imageURL)
        print(imagesRef)
        if let uploadData = self.firstImg.image?.jpegData(compressionQuality: 0.5) {
            storageRef.putData(uploadData, metadata:nil){  [self]  (metadata,error) in
                
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("image uploaded successfully")
                }
                
            }
        }
                    
    }
    
    @IBAction func tappedLocationBtn(_ sender: Any) {
    }
    @IBAction func tappedSubmitBtn(_ sender: Any) {
        
     // self.performSegue(withIdentifier: "map", sender: self)

        
        if Auth.auth().currentUser != nil {
          // User is signed in.
          // ...
            
            // get current logged in user key
            let userId = Auth.auth().currentUser?.uid
            
            self.videoURL = "video:\(userId!).mp4"
            
            //Make key to store the value
            let uid = self.ref.childByAutoId()
            
            let dict: [String: String] = [
                "id": uid.key!,
                "reportedBy": userId!,
                "userCar": "KIA PICANTO 2022",
                "reportedCar":"MEHRAN 1990",
                "location_lat": "",
                "location_long": "",
                "imageUrl": self.imageURL,
                "videoUrl": self.videoURL
            ]
            
            self.ref.child("Report").setValue(dict) { error, DatabaseReference in
                
                if error == nil {
                    //TODO: Move to home screen
                    
                } else {
                    
                }
            }
            
        } else {
          // No user is signed in.
          // ...
        }
                
    }
}

extension HomeVC : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        textView.text = ""
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textVu.text == "" {
            textVu.text = "More Information ..."
        }
        
    }
}

extension HomeVC : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.dismiss(animated: true) {
                // assigned image after picking from picker
                self.firstImg.image = image
            }
        }
    }}
