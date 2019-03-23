//
//  VMRestaurant.swift
//  Test
//
//  Created by Ubaid ur Rahman on 23/03/2019.
//  Copyright © 2019 Ubaid ur Rahman. All rights reserved.
//

import Foundation
import SwiftyJSON
public class VMRestaurant : NSObject{
    public var name:String! = ""
    public var id:String! = ""
    public var lat:Double! = 0.0
    public var long:Double! = 0.0
    public var rating:Float! = 0.0
    public var openNow:Bool! = false
    public var placeId:String! = ""
    public var icon:String! = ""
    
    //private singleton object
    private static var _obj:VMRestaurant? = nil
    //Singlton Propetry
    class var shared:VMRestaurant{
        get{
            if(_obj == nil){
                _obj = VMRestaurant()
            }
            
            let lockQueue = DispatchQueue(label: "obj")
            
            return lockQueue.sync {
                return _obj!
            }
        }
    }
    
    //prevent to create multiple ojects
    private override init() {
        print("Singleton -> VMRestaurant Initialized")
    }
    
    
    public func getData(forLat lat:Double,
                        andLong long:Double,
                        withRadius radius:Double,
                        successHandler success:@escaping ((_ data:[VMRestaurant])->Void),
                        failHandler fail:@escaping ((_ error:String)->Void) ) -> Void{
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        let parameters:[String:Any] = [
            "location":"\(lat),\(long)",
            "radius":radius,
            "type":"restaurant", //type restuarnt
            "key":APIKeys.GOOGLE_PACES_KEY
        ]
        
        let httpClient = BaseHttpClient()
        httpClient.makeJSONRequest(withUrl: url, method: "GET", headers: nil, parameters:parameters, success: { (responseObject) in
            var vmArr:[VMRestaurant] = [VMRestaurant]()
            let response = JSON.init(responseObject)
            guard let results = response["results"].array else{success(vmArr);return}
            for eachItem in results{
                let vm = VMRestaurant()
                vm.id = eachItem["id"].stringValue
                vm.placeId = eachItem["place_id"].stringValue
                vm.name = eachItem["name"].stringValue
                vm.icon = eachItem["icon"].stringValue
                vm.openNow = (eachItem["opening_hours"].dictionary?["open_now"]?.bool) ?? false
                vm.rating = eachItem["rating"].float ?? 0.0
                if let location = eachItem["geometry"].dictionary?["location"]?.dictionary{
                    vm.lat = location["lat"]?.doubleValue
                    vm.long = location["lng"]?.doubleValue
                }
                
                vmArr.append(vm)
            }
            
            vmArr = vmArr.sorted(by: {$0.rating > $1.rating})
            
            success(vmArr)
            
        }) { (error, responseObject) in
            if let e = error{
                fail(e.localizedDescription)
            }
        }
    }
    
}
