//
//  LoginVC.swift
//  AccidentApp
//
//  Created by Maryum Abdullah on 15/07/2023.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase


class LoginVC: UIViewController {

    @IBOutlet weak var forgotpwBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var pwFld: UITextField!
    @IBOutlet weak var emailFld: UITextField!
    
    @IBOutlet weak var backBtn: UIImageView!
    var ref = DatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        emailFld.tag = 0
        pwFld.tag = 1
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedImage))
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(tapGesture)

    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        emailFld.text = "a@bc.com"
        pwFld.text = "123456"
        
        guard let email = emailFld.text, !email.isEmpty else {
            displayMyAlertMessage (userMessage: "Please fill all fields")
            return
        }
        
        guard let pwd = pwFld.text, !pwd.isEmpty else {
            displayMyAlertMessage (userMessage: "Please fill all fields")
            return
        }
        
        if email == "a@dmin.com" && pwd == "@123456#" {
            //move to admin controller
            
        } else {
            
            //TODO: Firebase sign-in authentication

            Auth.auth().signIn(withEmail: email, password: pwd) { authResult, error in
              
                if authResult?.user.uid != nil {
                    
                    //TODO: Move to home controller
                    self.movetoHomeScreen()
                    
                } else {
                    self.displayMyAlertMessage(userMessage: error.debugDescription)
                }
                
            }
        }
 }
        
    
    @IBAction func forgotpwPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "forgot", sender: self)
    }
    
    
    //TODO: Display alert message

    func displayMyAlertMessage(userMessage:String){
        
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        //let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        myAlert.addAction(okAction)
        //        myAlert.addAction(cancelAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func movetoHomeScreen() {
        // self.performSegue(withIdentifier: "home", sender: self)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contoller = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        self.navigationController?.pushViewController(contoller, animated: true)
    }
    
    @objc func tappedImage(sender: UITapGestureRecognizer){
        print(#function)
        print(sender.view?.tag as Any)
        self.navigationController?.popViewController(animated: true)
     }
}
