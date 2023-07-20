//
//  SignupVC.swift
//  AccidentApp
//
//  Created by Maryum Abdullah on 15/07/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class SignupVC: UIViewController {
    
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var passwordFld: UITextField!
    @IBOutlet weak var emailFld: UITextField!
    @IBOutlet weak var nameFld: UITextField!
    
    @IBOutlet weak var backBtn: UIImageView!
    var ref = DatabaseReference.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        nameFld.tag = 0
        emailFld.tag = 1
        passwordFld.tag = 2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedImage))
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(tapGesture)

        
    }
    
    
    @IBAction func registerBtnPressed(_ sender: Any) {
       
        let name = nameFld.text
        let email = emailFld.text
        let password = passwordFld.text
        
        if name == "" {
            showAlert (message: "Please fill all fields")
            return
        }
        
        if email == "" {
            showAlert (message: "Please fill all fields")
            return
        }
        if password == "" {
            showAlert (message: "Please fill all fields")
            return
        }
        
        //TODO: Authentication to firebase
        Auth.auth().createUser(withEmail: email!, password: password!) { authResult, error in
          // ...
            if authResult?.user.uid != nil {
                //TODO: Upload dictionary object to firebase
                
                let dict = ["id": authResult?.user.uid,
                            "name":name!,
                            "email":email!,
                            "password":password!,
                            "role": "user",
                            "fcm": "" ]
                /*
                 Add user into firebase in User table
                 */
                self.ref.child("User").child((authResult?.user.uid)!).setValue(dict) { (error: Error?, ref: DatabaseReference) in

                    if let error = error {
                        //through an error
                        print("Data couldn't be saved: \(error.localizedDescription)")
                    } else {
                        
                        //TODO: Save to userdefaults
                        UserDefaults.standard.setValue(dict, forKey: "user")
                        UserDefaults.standard.synchronize()
                        
                        //TODO: Move to home screen
                        self.movetoHomeScreen()
                        
                    }
                }

            } else {
                self.showAlert(message: error.debugDescription)
            }
            
        }
        
    }

    
    @IBAction func signinBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "signin", sender: self)
    }
    
    func movetoHomeScreen() {
        self.performSegue(withIdentifier: "home", sender: self)
        
    }
    
    func showAlert(message:String){
        //TODO: Display alert msg
        
        let Alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        //let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        Alert.addAction(okAction)
        //        myAlert.addAction(cancelAction)
        self.present(Alert, animated: true, completion: nil)
    }
    
    @objc func tappedImage(sender: UITapGestureRecognizer){
        print(#function)
        print(sender.view?.tag as Any)
        self.navigationController?.popViewController(animated: true)
     }

}

extension SignupVC : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 0 {
            print("name field")
            self.nameFld.text = textField.text
        }
        if textField.tag == 1 {
            print("email field")
            self.emailFld.text = textField.text
            
        }
        if textField.tag == 2 {
            print("password field")
            self.passwordFld.text = textField.text
        }
        
    }
    
}
