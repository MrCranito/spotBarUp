//
//  map.swift
//  SpotBar
//
//  Created by Victor moreau on 06/03/2018.
//  Copyright © 2018 Victor moreau. All rights reserved.
//

import Foundation
import Alamofire

class MapServiceImp: mapService{
    func getNightClub(map: getStuff, completion: @escaping (String?, Error?) -> ()) {
        var x = map.location?.latitude
        var y = map.location?.longitude
        
        var localisation = x!.description+","+y!.description
        
        Alamofire.request("http://127.0.0.1:6003/map/getNightClub", method: .post, parameters: ["coordinateX": x,"coordinateY": y], encoding: JSONEncoding.default, headers: nil).responseString{ (data) in
            // NSLog("\(String(describing: data.result.value))")
            
            var datas = data.result.value;
            
            if let error = data.error{
                completion("nil" , error)
                
                return
            }
            
            
            completion(data.result.value!, nil)
            
        }
    }
  
    func getBar(map: getStuff, completion: @escaping (_ result: String?, Error?) -> ()) {
        var x = map.location?.latitude
        var y = map.location?.longitude
        
        var localisation = x!.description+","+y!.description
        
        Alamofire.request("http://127.0.0.1:6003/map/getBar", method: .post, parameters: ["coordinateX": x,"coordinateY": y], encoding: JSONEncoding.default, headers: nil).responseString{ (data) in
               // NSLog("\(String(describing: data.result.value))")
            
                var datas = data.result.value;
            
                if let error = data.error{
                    completion("nil" , error)
                
                    return
                }

        
        completion(data.result.value!, nil)
            
        }
    }
}
