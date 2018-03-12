//
//  mapService.swift
//  SpotBar
//
//  Created by Victor moreau on 06/03/2018.
//  Copyright © 2018 Victor moreau. All rights reserved.
//

import Foundation

protocol mapService{
    
    func getBar(map: getStuff, completion: @escaping(_ map: String?, _ error: Error? )->() )
    
    func getNightClub(map: getStuff, completion: @escaping(_ map: String?, _ error: Error? )->() )
    
    

    
}
