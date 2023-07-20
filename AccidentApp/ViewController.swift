//
//  ViewController.swift
//  AccidentApp
//
//  Created by Maryum Abdullah on 14/07/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            }


    @IBAction func startBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "signup", sender: self)

    }
    
}

