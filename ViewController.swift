//
//  ViewController.swift
//  To-do
//
//  Created by Hemanth Kotla on 2019-12-04.
//  Copyright © 2019 Hemanth Kotla. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Email: UITextField!
    
    var uid: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Email.text = ""
        Password.text = ""
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         Email.text = ""
        Password.text = ""
               
    }


    @IBAction func Register(_ sender: Any) {
        
        if Email.text != nil && Password.text != nil
        {
            Auth.auth().createUser(withEmail: Email.text!, password: Password.text!) { (result, error) in
                if error != nil
                {
                    print("error present")
                }
                else
                {
                    
                    self.uid = (result?.user.uid)!

                    let ref = Database.database().reference(withPath: "users").child(self.uid)
                    ref.setValue(["email": self.Email.text!, "password":self.Password.text!])
                    self.performSegue(withIdentifier: "Todo", sender: self)
                }
            }
        }
    }
    @IBAction func Login(_ sender: Any) {
        
        if Email.text != nil && Password.text != nil
        {
            Auth.auth().signIn(withEmail: Email.text!, password: Password.text!)
            {
                (result, error) in if error != nil
                {
                    print("error")
                }
                else
                {
                    self.uid = (result?.user.uid)!
                    self.performSegue(withIdentifier: "Todo", sender: self)
//
                }
            }
        }
        
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigation = segue.destination as! UINavigationController
        let todoVC = navigation.topViewController as! Todoview
        todoVC.userID = uid
         }
    
}

