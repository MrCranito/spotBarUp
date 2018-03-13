//
//  UserViewController.swift
//  SpotBar
//
//  Created by Victor moreau on 27/02/2018.
//  Copyright © 2018 Victor moreau. All rights reserved.
//

import Foundation
import UIKit

class UserRegister : UIViewController {
    
    
    @IBOutlet weak var firstname: UITextField!
    
    @IBOutlet weak var lastname: UITextField!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!

    var userService: UserService?
    
    func windowsError(title : String?, message : String?){
        let alert = UIAlertController(title : title, message : message, preferredStyle : UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title : "OK", style : UIAlertActionStyle.default, handler : {
            (action) in
            alert.dismiss(animated : true, completion : nil)
            if alert.title == "Votre Compte à bien été créé !"{
                 self.performSegue(withIdentifier: "mapViewRegister", sender: self)
            }
           
        }))
         self.present(alert, animated: true, completion: nil)
        
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
   
        @IBAction func register(_ sender: Any) {
            let checkEmail = validateEmail(enteredEmail: email.text!)
             if(checkEmail == true){
                let user = User(name: firstname.text!, lastname: lastname.text!, email: email.text!, password: password.text!, friendList: [], coordinateX: 0, coordinateY: 0, localisationActived: true)
                userService?.register(user: user, completion: {(user: User?, error: Error?) in
                    if error != nil {
                        self.windowsError(title: "Error on Registering", message: "Something may wrong with your ID or Our DB is crashed")
                        return
                    }
                    else{
                        self.windowsError(title : "Votre Compte à bien été créé !", message :"Démarrer la soirée")
                        NSLog("Success")
                        NSLog("\(self.firstname.text, self.lastname.text, self.password.text, self.email.text)")
                        
                    }
                })
            }
             else{
                windowsError(title: "ALert on Your Email", message: "Your Email doesn't correspond to the format : test@mytest.com")
            }
        }
            
    }

