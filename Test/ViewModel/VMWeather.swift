//
//  VMWeather.swift
//  Test
//
//  Created by Ubaid ur Rahman on 23/03/2019.
//  Copyright © 2019 Ubaid ur Rahman. All rights reserved.
//

import Foundation
import SwiftyJSON

public class VMWeather :NSObject{
    public var country:String!
    public var city:String!
    public var pressure:Float!
    public var wind:Float!
    public var humidity:Float!
    public var temperature:Float!
    public var text:String!
    public var dateTimeStamp:Int32!
    
    //private singleton object
    private static var _obj:VMWeather? = nil
    //Singlton Propetry
    class var shared:VMWeather{
        get{
            if(_obj == nil){
                _obj = VMWeather()
            }
            
            let lockQueue = DispatchQueue(label: "obj")
            
            return lockQueue.sync {
                return _obj!
            }
        }
    }
    
    //prevent to create multiple ojects
    private override init() {
        print("Singleton -> VMWeather Initialized")
    }
    
    public func getData(forLat lat:Double,
                        andLong long:Double,
                        forDays days:Int,
                        successHandler success:@escaping ((_ current:VMWeather, _ forecast:[VMWeather])->Void),
                        failHandler fail:@escaping ((_ error:String)->Void) ) -> Void{
        
        let url = "https://api.apixu.com/v1/forecast.json"
        let parameters = [
            "q":"\(lat),\(long)",
            "days":days,
            "key":APIKeys.WEATHER_KEY
            ] as [String : Any]
        
        
        let client = BaseHttpClient()
        client.makeJSONRequest(withUrl: url, method: "GET", headers: nil, parameters: parameters, success: { (responseObject) in
            let json = JSON.init(responseObject)
            let current = VMWeather()
            current.city = json["location"].dictionary?["tz_id"]?.string ?? "Region : N/A"
            current.country = json["location"].dictionary?["country"]?.string ?? "Country : N/A"
            current.dateTimeStamp = json["location"].dictionary?["localtime_epoch"]?.int32 ?? 0
            current.temperature = json["current"].dictionary?["temp_c"]?.float ?? 0.0
            current.wind = json["current"].dictionary?["temp_c"]?.float ?? 0.0
            current.pressure = json["current"].dictionary?["precip_in"]?.float ?? 0.0
            current.humidity = json["current"].dictionary?["humidity"]?.float ?? 0.0
            current.text = json["current"].dictionary?["condition"]?.dictionary?["text"]?.string ?? ""
            
            var forecast = [VMWeather]()
            
            var jsonArr = json["forecast"].dictionary?["forecastday"]?.array ?? [JSON]()
            
            for i in (1 ..< jsonArr.count){
                let eachItem = jsonArr[i]
                let vm = VMWeather()
                vm.dateTimeStamp = eachItem["date_epoch"].int32 ?? 0
                vm.temperature = eachItem["day"].dictionary?["avgtemp_c"]?.float ?? 0
                vm.pressure = eachItem["day"].dictionary?["totalprecip_in"]?.float ?? 0
                vm.humidity = eachItem["day"].dictionary?["avghumidity"]?.float ?? 0
                vm.wind = eachItem["day"].dictionary?["avgvis_km"]?.float ?? 0
                
                forecast.append(vm)
            }
            
            forecast = forecast.sorted(by: {$0.dateTimeStamp < $1.dateTimeStamp})
            
            success(current,forecast)
            
        }) { (error, responseObject) in
            guard let e  = error else{return}
            fail(e.localizedDescription)
        }
        
    }
}
