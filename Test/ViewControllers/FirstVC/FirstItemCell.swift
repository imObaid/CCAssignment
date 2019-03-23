//
//  FirstItemCell.swift
//  Test
//
//  Created by Ubaid ur Rahman on 23/03/2019.
//  Copyright © 2019 Ubaid ur Rahman. All rights reserved.
//

import UIKit
import SDWebImage
class FirstItemCell: UITableViewCell {
    
    static var cellId:String = "FirstItemCell"

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelOpenNow: UILabel!
    @IBOutlet weak var imgViewIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.selectionStyle = .none
    }
    
    func bindData(_ data:VMRestaurant){
        labelName.text = data.name!
        labelRating.text = "Rating : \(data.rating!)"
        
        if data.openNow!{
            labelOpenNow.isHidden = false
        }else{
            labelOpenNow.isHidden = true
        }
        
        let placeholder = UIImage.init(named: "placeholder")
        imgViewIcon.sd_setImage(with: URL(string: data.icon!), placeholderImage: placeholder)
    }
    
}
