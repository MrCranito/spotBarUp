//
//  File.swift
//  SpotBar
//
//  Created by Victor moreau on 27/02/2018.
//  Copyright © 2018 Victor moreau. All rights reserved.
//

import Foundation
import UIKit

class UserSignIn : UIViewController {
    
    var userMail : mailUser?
    
    @IBOutlet weak var mailSignin: UITextField!
    
    @IBOutlet weak var passwordSignin: UITextField!
    
    var userService: UserService?

    var mailcheckup : Bool!
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    
    func windowsError(title : String?, message : String?){
        let alert = UIAlertController(title : title, message : message, preferredStyle : UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title : "OK", style : UIAlertActionStyle.default, handler : {
            (action) in
            alert.dismiss(animated : true, completion : nil)
            self.performSegue(withIdentifier: "mapViewSignIn", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func SignUp(_ sender: Any) {
       let checkEmail = validateEmail(enteredEmail: mailSignin.text!)
       if(checkEmail == true){
            let user = SignIn(email: mailSignin.text!, password: passwordSignin.text!)
            userService?.signIn(user: user, completion: {(user: SignIn?, error: Error?) in
                
                if error != nil {
                    self.windowsError(title : "Error On LoginIn", message :"Mail or Password Doesn't Match")
                    return
                }
                self.windowsError(title: "Connection Réussit", message: "Vous etes maintenant connecté")
                NSLog("Success")
                self.userMail?.email = self.mailSignin.text!
                
            })
        }
        else{
        windowsError(title : "Error On LoginIn", message :"Mail isn't conform to the format : test@myaddress.com")
        }
    }
    
}
