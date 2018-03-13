//
//  UserInject.swift
//  SpotBar
//
//  Created by Victor moreau on 27/02/2018.
//  Copyright © 2018 Victor moreau. All rights reserved.
//

import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard{
    
    @objc class func setup(){
        
        defaultContainer.register(UserService.self){_ in UserServiceImp() }
        
        defaultContainer.storyboardInitCompleted(UserRegister.self){
            r, UserRegister in
            UserRegister.userService = r.resolve(UserService.self)
        }
        
        
        defaultContainer.register(mapService.self){_ in MapServiceImp()}
        
        
        defaultContainer.storyboardInitCompleted(UserSignIn.self){
            r, UserSignIn in
            UserSignIn.userService = r.resolve(UserService.self)
        }
        

        defaultContainer.storyboardInitCompleted(DataViewController.self){
            r, DataViewController in
            DataViewController.mapService = r.resolve(mapService.self)
        }
        
        defaultContainer.storyboardInitCompleted(DataViewController.self){
            r, DataViewController in
            DataViewController.userService = r.resolve(UserService.self)
        }
        
        defaultContainer.storyboardInitCompleted(userView.self){
            r, userView in
            userView.userService = r.resolve(UserService.self)
        }
        
    }
}
