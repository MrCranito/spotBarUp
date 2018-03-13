//
//  File.swift
//  SpotBar
//
//  Created by Victor moreau on 27/02/2018.
//  Copyright © 2018 Victor moreau. All rights reserved.
//

import Foundation

protocol UserService{
    
    func register(user: User, completion: @escaping(_ user: User?, _ error: Error? )->() )
    
    func signIn(user: SignIn, completion: @escaping(_ user: SignIn?, _ error: Error? )->() )
    
    func connectDB(params: checkSchema, completion: @escaping (checkSchema?, Error?) -> () )
    
    func getUserFriend(params: User, completion: @escaping(User?, _ error: Error?) -> () )
    
    func getUser(params: SignIn, completion: @escaping(String?, _ error: Error?) -> () )
    
    func addFriend(params: mailUser?, completion: @escaping(_ params: mailUser?, _ error: Error? )->() )
}
