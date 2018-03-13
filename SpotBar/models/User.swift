//
//  User.swift
//  SpotBar
//
//  Created by Victor moreau on 27/02/2018.
//  Copyright © 2018 Victor moreau. All rights reserved.
//

import Foundation
class User {
    var name : String?
    var lastname : String?
    var email : String?
    var password : String?
    var friendList : Array<Any>
    var coordinateX : Int?
    var coordinateY: Int?
    var localisationActived: Bool
    
    init(name: String, lastname: String, email : String, password: String, friendList : Array<Any>, coordinateX: Int, coordinateY: Int, localisationActived : Bool){
        self.name = name
        self.lastname = lastname
        self.email = email
        self.password = password
        self.friendList = friendList
        self.coordinateX = coordinateX
        self.coordinateY = coordinateY
        self.localisationActived = localisationActived
    }
}
