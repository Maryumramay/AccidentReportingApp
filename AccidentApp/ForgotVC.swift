//
//  ForgotVC.swift
//  AccidentApp
//
//  Created by Maryum Abdullah on 15/07/2023.
//

import UIKit
import FirebaseAuth

class ForgotVC: UIViewController {

    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var codeFld: UITextField!
    
    @IBOutlet weak var backBtn: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedImage))
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(tapGesture)

    }
    
        
    @IBAction func verifyBtnPressed(_ sender: Any) {
        let email = self.codeFld.text
        
        if self.codeFld.text?.isEmpty == false {
            showAlert (message: "Email has sent")
            return
        }
        if email == "" {
            showAlert (message: "Please enter your email address")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
            DispatchQueue.main.async {
                //hide loader


                if let error = error {
                    //show alert here
                    print(error.localizedDescription)
                }
                else {
                    //show alert here
                    print("We send you an email with instructions on how to reset your password.")
                }
            }
        }
    }
    func showAlert(message:String){
        
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

    
    
    



