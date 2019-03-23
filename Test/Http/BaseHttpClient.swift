//
//  BaseHttpClient.swift
//  SwiftPractice
//
//  Created by Ubaid ur Rahman on 11/09/2017.
//  Copyright © 2017 Ubaid ur Rahman. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
            debugPrint(self)
        #endif
        return self
    }
}

class BaseHttpClient: NSObject {
        
    private func getFullUrl(partialUrl:String) -> String {
        return "\(ApiConstants.baseUrl)\(partialUrl)"
    }
    
    private func getRequestMethodType(method requestMethod:String)->HTTPMethod?{
        var requestMethodType:HTTPMethod?
        switch requestMethod {
        case "GET":
            requestMethodType = .get
            break;
        case "POST":
            requestMethodType = .post
            break;
        case "PUT":
            requestMethodType = .put
            break;
        case "DELETE":
            requestMethodType = .delete
            break;
        default:
            print("ERROR IN HTTP METHOD")
            //requestMethodType = "N/A"//HTTPMethod(rawValue: "N/A")!
        }
        
        return requestMethodType
    }
    
    private func printRequestLog(url:String , method:HTTPMethod ,parameters:[String:Any]? , headers:[String:String]?){
        print("METHOD TYPE: \(method)")
        print("URL : \(url)")
        print("REQUEST HEADERS : \(headers)")
        print("REQUEST PARAMETERS : \(parameters)")
    }
    
    private func responseDataToJSON(data responseData:Data?) -> Any? {
        guard let resData = responseData else{return nil}
        guard let json =  try? JSON(data:resData) else{return nil}
        let responseObject = json.dictionaryObject as Any
        return responseObject
    }
    
    func makeJSONRequest(withPartialUrl url:String, method requestMethod:String,
                         headers requestHeaders:[String:String]? , parameters requestParameters:[String:Any]?,
                         success successHandler:@escaping(_ responseObject:Any)->Void ,
                         fail failHandler:@escaping(_ error:Error? , _ responseObject : Any)->Void){
        self.makeJSONRequest(withUrl: self.getFullUrl(partialUrl: url), method: requestMethod, headers: requestHeaders, parameters: requestParameters, success: successHandler, fail: failHandler)
    }
    
    func makeJSONRequest(withUrl url:String, method requestMethod:String,
                         headers requestHeaders:[String:String]? , parameters requestParameters:[String:Any]?,
                         success successHandler:@escaping(_ responseObject:Any)->Void ,
                         fail failHandler:@escaping(_ error:Error? , _ responseObject : Any)->Void){
        
        //set request method
        guard let requestMethodType:HTTPMethod = self.getRequestMethodType(method: requestMethod) else{return}
       
        //check headers
        var headers : [String:String]? = requestHeaders
        if(headers == nil){
            headers = [String:String]()
        }
        
        var parameters = requestParameters
        if parameters == nil{
            parameters = [String:Any]()
        }
        
        //print request log
        self.printRequestLog(url: url, method: requestMethodType, parameters: parameters, headers: headers!)
        
        let encoding:ParameterEncoding = requestMethodType == .get ? URLEncoding() : JSONEncoding()
       
        //make request
        Alamofire.request(url, method: requestMethodType, parameters: parameters!, encoding: encoding, headers: headers!).validate().debugLog().responseJSON { (response) in
            
            switch response.result {
            case .success:
                print("SUCCESS SERVER RESPONSE : \(response.result.value as Any)")
                successHandler(response.result.value as Any)
            case .failure(let err):
                print("REQUEST FAILED : \(err.localizedDescription)")
                let resObj = self.responseDataToJSON(data: response.data)
                if let data = resObj {
                    print("SERVER FAILED RESPONSE : \(data as Any)")
                    failHandler(err , data as Any)
                }else{
                    print("SERVER FAILED RESPONSE : \(response.result.value as Any)")
                    failHandler(err , response.result.value as Any)
                }
            }
        }
    }
    
    func makeHttpRequest(withPartialUrl url:String, method requestMethod:String,
                         headers requestHeaders:[String:String]? , parameters requestParameters:[String:Any]?,
                         success successHandler:@escaping(_ responseObject:Any)->Void ,
                         fail failHandler:@escaping(_ error:Error? , _ responseObject : Any)->Void){
        
       self.makeHttpRequest(withUrl: self.getFullUrl(partialUrl: url), method: requestMethod, parameters: requestParameters, headers: requestHeaders, success: successHandler, fail: failHandler)

    }

    
    func makeHttpRequest(withUrl url:String, method requestMethod:String ,
                         parameters requestParameters:[String:Any]?,
                         headers requestHeaders:[String:String]?,
                         success successHandler:@escaping(_ responseObject:Any)->Void,
                         fail failHandler:@escaping(_ error:Error? , _ responseObject:Any)->Void){
        
        //set request method
        guard let requestMethodType:HTTPMethod = self.getRequestMethodType(method: requestMethod) else{return}
       
        //check parameters
        var parameters : [String:Any]? = requestParameters
        if(parameters == nil){
            parameters = [String:Any]()
        }
        
        //check headers
        var headers : [String:String]? = requestHeaders
        if(headers == nil){
            headers = [String:String]()
        }
        
        //print request log
        self.printRequestLog(url: url, method: requestMethodType, parameters: parameters!, headers: headers!)
        
        //make request
        Alamofire.request(url, method: requestMethodType, parameters: parameters!, encoding:URLEncoding.default, headers: headers!).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                print("SUCCESS SERVER RESPONSE : \(response.result.value as Any)")
                successHandler(response.result.value as Any)
            case .failure(let err):
                print("REQUEST FAILED : \(err.localizedDescription)")
                let resObj = self.responseDataToJSON(data: response.data)
                if let data = resObj {
                    print("SERVER FAILED RESPONSE : \(data as Any)")
                    failHandler(err , data as Any)
                }else{
                    print("SERVER FAILED RESPONSE : \(response.result.value as Any)")
                    failHandler(err , response.result.value as Any)
                }
            }
        }
        
    }
    
    func upload(fileData data:Data,
                withUrl url:String,
                method requestMethod:String,
                fileName name:String,
                mimeType type:String,
                parameterName fileParameterName:String,
                headers requestHeaders:[String:String]?,
                parameters requestParameters:[String:String]?,
                success successHandler:@escaping(_ responseObject:Any)->Void ,
                fail failHandler:@escaping(_ error:Error? , _ responseObject : Any)->Void,
                progress progressHandler:((_ progress:Double)->())?){
        
        //set request method
        guard let requestMethodType:HTTPMethod = self.getRequestMethodType(method: requestMethod) else{return}
        
        //check parameters
        var parameters : [String:Any]? = requestParameters
        if(parameters == nil){
            parameters = [String:Any]()
        }
        
        //check headers
        var headers : [String:String]? = requestHeaders
        if(headers == nil){
            headers = [String:String]()
        }
        
        //print request log
        self.printRequestLog(url: url, method: requestMethodType, parameters: parameters!, headers: headers!)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(data, withName: fileParameterName, fileName: name, mimeType: type)
                
                //adding parameters
                for (key, value) in requestParameters! {
                    let paraData:Data? = (value as String).data(using: String.Encoding.utf8)
                    
                    if let para = paraData{
                        multipartFormData.append(para, withName: key)
                    }
                    
                }
        },
            to: url,
            method:requestMethodType,
            headers:headers!,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.validate().uploadProgress { progress in
                        print("upload progess : \(progress.fractionCompleted)")
                        
                        if(progressHandler != nil){
                            progressHandler!(progress.fractionCompleted)
                        }
                        
                        }.responseJSON { response in
                        switch response.result {
                        case .success:
                            print("SUCCESS SERVER RESPONSE : \(response.result.value as Any)")
                            successHandler(response.result.value as Any)
                        case .failure(let err):
                            print("REQUEST FAILED : \(err.localizedDescription)")
                            let resObj = self.responseDataToJSON(data: response.data)
                            if let data = resObj {
                                print("SERVER FAILED RESPONSE : \(data as Any)")
                                failHandler(err , data as Any)
                            }else{
                                print("SERVER FAILED RESPONSE : \(response.result.value as Any)")
                                failHandler(err , response.result.value as Any)
                            }
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }
}
