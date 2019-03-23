//
//  ApiConstants.swift
//  SwiftPractice
//
//  Created by Ubaid ur Rahman on 12/09/2017.
//  Copyright © 2017 Ubaid ur Rahman. All rights reserved.
//

import Foundation

typealias RequestFailedCallback = ((_ error:String)->Void)

struct ApiConstants {
    
    //app basic authorization headers
    static let BASIC_AUTHORIZATION_HEADER:[String:String] = ["Authorization":"some key"]
    static let baseUrl = "http://somebackendurlhere/api/"

}
