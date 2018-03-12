//
//  DataViewController.swift
//  SpotBar
//
//  Created by Victor moreau on 07/02/2018.
//  Copyright © 2018 Victor moreau. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class DataViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var addFriend: UITextField!
    
    @IBOutlet weak var userMail: UITextField!
    @IBAction func addToListFriend(_ sender: Any) {
        
        let emailUser = userMail.text!
        let emailFriend = addFriend.text!
        let test = mailUser(email: emailUser, emailFriend : emailFriend)
        
        
        userService?.addFriend(params: test, completion : {(params : mailUser?, Error: Error?) in
            if(Error != nil){
                return
            }
            else{
                NSLog("Friend Added")
            }
        })
    }
    @IBAction func showFriend(_ sender: Any) {
        let test = User(name: "ok", lastname: "ok", email : "best@test.com", password: "ok", friendList: [], coordinateX:0, coordinateY:0 , localisationActived : true)
        userService?.getUserFriend(params: test, completion: {(params: User?, error: Error?) in
            if error != nil {
                NSLog("\(String(describing: error))")
                return
            }
            else{
                for item in (params?.friendList)!{ /////// BUGGED HERE //// ADD Usermail aumatiquely // field addfriend
                    
                    print(item)
                    let json = User(name:"", lastname:"", email: item as! String, password:"", friendList:[], coordinateX:0, coordinateY:0 , localisationActived : true)
                    self.userService?.getUser(params: json, completion: { (params : User?, error :Error?) in
                        if(error != nil){
                            return
                        }
                        else{
                            print("ok")
                        }
                    })
                }
            }
        })
    }
    var mapService : mapService?
    var userService : UserService?
    
    func checkDBIfExists(){
        print("ok")
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate2DUser.latitude, longitude: coordinate2DUser.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            var state = placeMark.addressDictionary!["State"]
            var country = placeMark.addressDictionary!["Country"]
            
            let json = checkSchema(state: state as! String, country : country as! String)
            print(json.country, json.state)
            self.userService?.checkSchema(params: json, completion: {(checkSchema: checkSchema?, error : Error?) in
                if error != nil {
                    NSLog("\(String(describing: error))")
                    return
                }
                else{
                    NSLog("\(checkSchema)")
                }
            })
        })
        
       
    }
    func getBar (){
        let mapInfo = getStuff(location: mapBar.centerCoordinate)
        mapService?.getBar(map: mapInfo, completion: { (map: String?, error: Error?) in
            if error != nil {
                NSLog("\(String(describing: error))")
                return
            }
            else{
                NSLog("Success")
                //NSLog("this is map result \(map)")
                var loc = [[String: Any]]()
                
                do {
                    if  let data = map?.data(using: String.Encoding.utf8, allowLossyConversion: false),
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let blogs = json["result"] as? [[String: Any]] {
                        for blog in blogs {
                           loc.append(blog)
                        }
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                
                //NSLog("\(loc[0])")
                for item in loc {
                    let coordinateX = item["coordinateX"]
                    let coordinateY = item["coordinateY"]
                    let title = item["barName"]
                    
                    let coorBar = CLLocationCoordinate2DMake(coordinateX as! Double, coordinateY as! Double);
                    
                    //var barAnnotation = MKPointAnnotation()

                    let titleBar = title as! String
                    let barAnnotation = BarAnnotation(coordinate: coorBar, title: titleBar, identifier : "Bar")
                    self.mapBar.addAnnotation(barAnnotation)
                    
                    
                }
                
            }
         })
    }
    func getNightClub (){
        let mapInfo = getStuff(location: mapBar.centerCoordinate)
        mapService?.getNightClub(map: mapInfo, completion: { (map: String?, error: Error?) in
            if error != nil {
                NSLog("\(String(describing: error))")
                return
            }
            else{
                //NSLog("Success")
                //NSLog("this is map result \(map)")
                var loc = [[String: Any]]()
                
                do {
                    if  let data = map?.data(using: String.Encoding.utf8, allowLossyConversion: false),
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let blogs = json["result"] as? [[String: Any]] {
                        for blog in blogs {
                            loc.append(blog)
                          
                        }
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                
               // NSLog("\(loc[0])")
                for item in loc {
                    
                    let coordinateX = item["coordinateX"]
                    let coordinateY = item["coordinateY"]
                    let title = item["barName"]
                    //NSLog("\(title)")
                    let coorBar = CLLocationCoordinate2DMake(coordinateX as! Double, coordinateY as! Double);
                    
                    var barAnnotation = MKPointAnnotation()
                    
                    let titlenightClub = title as! String
                    let nightClubAnnotation = BarAnnotation(coordinate: coorBar, title: titlenightClub, identifier : "NightClub")
                    
                    //NSLog("\(self.mapBar.region)")
                    self.mapBar.addAnnotation(nightClubAnnotation)
                    
                    
                }
                
            }
        })
    }
    
    var startMapItem = MKMapItem()
    var destinationMapItem = MKMapItem()
    
    var TobaccoStatus : Bool?
    var BarStatus : Bool?
    var NightClubStatus : Bool?
    
    @IBAction func TobaccoSwitch(_ sender: UISwitch) {
        if sender.isOn{
            TobaccoStatus = true;
        }
        else{
            TobaccoStatus = false;
        }
    }
    
    @IBAction func BarSwitch(_ sender: UISwitch) {
        if sender.isOn{
            BarStatus = true;
        }
        else{
            BarStatus = false;
        }
    }
    
    @IBAction func NightClubSwitch(_ sender: UISwitch) {
        if sender.isOn{
            NightClubStatus = true;
        }
        else {
            NightClubStatus = false;
        }
    }
    
    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: String = ""
    let locationManager  = CLLocationManager()
    
    

    @IBAction func findMe(_ sender: UISegmentedControl) { ///DECOMMENT WHEN IT'LL BE GOOD
        setUpCoreLocation()
       // getBar()
        //getNightClub()
       // let allannatotations = self.mapBar.annotations
       // for item in allannatotations{
         //   mapView(self.mapBar, viewFor: item)
        //}
        
   
    }
    
    
    var coordinate2DUser = CLLocationCoordinate2DMake(43.605090, 1.447847)
    

    @IBOutlet weak var mapBar: MKMapView!
    
    func setUpCoreLocation(){
        print(CLLocationManager.authorizationStatus())
         switch CLLocationManager.authorizationStatus(){
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
                break
            case .authorizedAlways, .authorizedWhenInUse:
                enableLocationServices()
            default:
                break
            }
    }
    
    func enableLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            let userPin = MKPointAnnotation()
            userPin.coordinate = coordinate2DUser
            userPin.title = "Votre position actuelle"
            mapBar.addAnnotation(userPin)
            
           // updateMapBar(rangeSpan: 200)
            //mapBar.setUserTrackingMode(.follow, animated: true)
            print("enable Location service")
        }
        if CLLocationManager.headingAvailable(){
            locationManager.startUpdatingHeading()
        } else {
            print("heading not available")
        }
    }
    
    func disableLocationService(){
        locationManager.stopUpdatingLocation()
        
    }

    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                print("authorized here")
                setUpCoreLocation()
            case .denied, .restricted:
                print("not authorized")
            default:
                break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("updateLocation")
        let location = locations.last!
        print(location)
        coordinate2DUser = location.coordinate
        //updateMapBar(rangeSpan: 200)
        
    }
    
    func updateMapBar(rangeSpan : CLLocationDistance){
        let region = MKCoordinateRegionMakeWithDistance(coordinate2DUser, rangeSpan, rangeSpan)
        mapBar.region  = region
        
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let allAnnotations = self.mapBar.annotations
        print(allAnnotations)
        if allAnnotations.count > 50 {
              mapBar.removeAnnotations(allAnnotations)
        }
      
        //searchByChoice()
//        requestNightClub()
//        requestBar()
//        requestTobacco()
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = MKAnnotationView()
        guard let annotation = annotation as? BarAnnotation
            else{
                return nil
        }
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier) {
            annotationView = dequedView
        } else {
            var distanceLat = mapBar.region.span.latitudeDelta / 2
            var distanceLong = mapBar.region.span.longitudeDelta / 2
            
            var distanceRight = mapBar.region.center.longitude + distanceLat
            var distanceTop = mapBar.region.center.latitude + distanceLong
            
            var distanceLeft = mapBar.region.center.longitude - distanceLat
            var distancebottom = mapBar.region.center.latitude - distanceLong
            
          
            if(distanceLeft < annotation.coordinate.longitude && annotation.coordinate.longitude < distanceRight){
                if( distancebottom < annotation.coordinate.latitude && annotation.coordinate.latitude < distanceTop){
                        NSLog("ok i got this")
                        sleep(1)
                        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
                }
            }
            else{
                NSLog("outside")
                let allAnnotations = self.mapBar.annotations
                self.mapBar.removeAnnotations(allAnnotations)
            
            }
            
        }
        //annotationView.pinTintColor = UIColor.blue
        switch annotation.identifier{
            case "Bar" :
                annotationView.image = UIImage(named: "bar")
            case "NightClub":
                annotationView.image = UIImage(named: "Night_Club")
            case "Tobacco":
                annotationView.image = UIImage(named: "Tobacco")
            default:
                return nil
        }
        
        
        
        
        return annotationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapBar.delegate = self
        setUpCoreLocation()
        //checkDBIfExists()
        updateMapBar(rangeSpan: 400)

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.dataLabel!.text = dataObject
    }
    
   
}
