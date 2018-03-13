//
//  userView.swift
//  SpotBar
//
//  Created by Victor moreau on 12/03/2018.
//  Copyright © 2018 Victor moreau. All rights reserved.
//

import Foundation
import UIKit

class userView : UIViewController{
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPwd: UITextField!
    @IBOutlet weak var userLoc: UITextField!
    @IBOutlet weak var userFriendList: UITableView!
    
    var userService: UserService?
    var userData : SignIn?
    var responseLoc : String?
   
    var datafromLogin = UserSignIn()
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
    }
    
    func getUserData(){
        var email : String?
        var pwd : String?
        var count = 0
        print("get user data")
        var getDataFromStruct = datafromLogin.getStructure.returnData()
        for item in getDataFromStruct{
            if(count == 0){
                email = item
                count = 1
            }
            else{
                pwd = item
            }
        }
        var userInfo = SignIn(email : email!, password : pwd!)
        userService?.getUser(params: userInfo, completion: { (user : String?, error : Error?) in
            if(error.self != nil){
                return
            }
            else{
                var userData = [[String: Any]]()
                
                do {
                    if  let data = user?.data(using: String.Encoding.utf8, allowLossyConversion: false),
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let blogs = json["result"] as? [[String: User]] {
                        for blog in blogs {
                            userData.append(blog)
                        }
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                print(userData)
            }
        })
    }
    
}
