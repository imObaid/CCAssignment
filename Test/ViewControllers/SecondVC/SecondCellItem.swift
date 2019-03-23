//
//  SecondCellItem.swift
//  Test
//
//  Created by Ubaid ur Rahman on 23/03/2019.
//  Copyright © 2019 Ubaid ur Rahman. All rights reserved.
//

import UIKit

class SecondCellItem: UICollectionViewCell {
    
    static var cellId:String = "SecondCellItem"
    
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelTemp: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindDate(_ data:VMWeather){
        self.labelDay.text = Date.init(timeIntervalSince1970: TimeInterval(data.dateTimeStamp!)).toString(withFormat: "EEE")
        self.labelTemp.text = "\(data.temperature!)"
    }

}
