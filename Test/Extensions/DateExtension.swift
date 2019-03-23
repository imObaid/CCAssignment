//
//  DateExtension.swift
//  Test
//
//  Created by Ubaid ur Rahman on 23/03/2019.
//  Copyright © 2019 Ubaid ur Rahman. All rights reserved.
//

import Foundation

extension Date{
    func toString(withFormat format:String = "yyyy-MM-dd") -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        let currentDateString: String = dateFormatter.string(from: self)
        return currentDateString
    }
}
