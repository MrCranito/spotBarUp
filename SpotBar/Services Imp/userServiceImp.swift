//
//  File.swift
//  SpotBar
//
//  Created by Victor moreau on 27/02/2018.
//  Copyright © 2018 Victor moreau. All rights reserved.
//

import Foundation
import Alamofire

class UserServiceImp: UserService {
    func getUser(params: SignIn, completion: @escaping (String?, Error?) -> ()) {
        print(params.email)
        
        Alamofire.request("http://127.0.0.1:6003/auth/getUser", method: .post, parameters: ["email": params.email ?? "email"], encoding: JSONEncoding.default, headers: nil).responseString{ (data) in
            NSLog("\(String(describing: data.result.value))")
            
            var datas = data.result.value
            
            if let error = data.error{
                completion(nil , error)
                NSLog("\(String(describing: error))")
                
                return
            }
            print(data)
            completion(data.result.value, nil)
        }
    }
    
    
    func connectDB(params: checkSchema, completion: @escaping (checkSchema?, Error?) -> ()) {
        print("ok here too")
        Alamofire.request("http://127.0.0.1:6003/auth/connectDB", method: .post, parameters: ["country": params.country ?? "country", "state": params.state ?? "state"], encoding: JSONEncoding.default, headers: nil).responseString{ (data) in
            NSLog("\(String(describing: data.result.value))")
            
            var datas = data.result.value
            
            if let error = data.error{
                completion(nil , error)
                NSLog("\(String(describing: error))")
                
                return
            }
            print(data)
            completion(params, nil)
        }
    }
    
    func signIn(user: SignIn, completion: @escaping (SignIn?, Error?) -> ()) {
        Alamofire.request("http://127.0.0.1:6003/auth/checkuser", method: .post, parameters: ["email": user.email ?? "email", "password": user.password ?? "password"], encoding: JSONEncoding.default, headers: nil).responseString{ (data) in
            NSLog("\(String(describing: data.result.value))")
            
            var datas = data.result.value
            
            if let error = data.error{
                completion(nil , error)
                
                
                return
            }
            
            completion(user, nil)
        }
    }
    func register(user: User, completion: @escaping (User?, Error?) -> ()) {
        Alamofire.request("http://127.0.0.1:6003/auth/createUser", method: .post, parameters: ["username": user.name ?? "username", "name": user.lastname ?? "name", "email": user.email ?? "email", "password": user.password ?? "password"], encoding: JSONEncoding.default, headers: nil).responseString{ (data) in
            NSLog("\(String(describing: data.result.value))")
            if let error = data.error{
                completion(nil , error)
                
                
                return
            }
            
            completion(user, nil)
        }
        
    }
    func addFriend(params: mailUser?, completion: @escaping (mailUser?, Error?) -> ()) {
        Alamofire.request("http://127.0.0.1:6003/auth/addFriend", method: .get, parameters: ["email": params?.email ?? "email", "friend": params?.emailFriend ?? "friend"], encoding: JSONEncoding.default, headers: nil).responseString{ (data) in
            NSLog("\(String(describing: data.result.value))")
            
            var datas = data.result.value
            
            if let error = data.error{
                completion(nil , error)
                NSLog("\(String(describing: error))")
                
                return
            }
            print(data)
            completion(params, nil)
        }
    }
    func getUserFriend(params: User, completion: @escaping (User?, Error?) -> ()) {
        print("ok")
        Alamofire.request("http://127.0.0.1:6003/auth/getUserFriend", method: .post, parameters: ["email": params.email ?? "country"], encoding: JSONEncoding.default, headers: nil).responseString{ (data) in
            NSLog("\(String(describing: data.result.value))")
            
            var datas = data.result.value
            
            if let error = data.error{
                completion(nil , error)
                NSLog("\(String(describing: error))")
                
                return
            }
            print(data)
            completion(params, nil)
        }
    }
}
