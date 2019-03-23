//
//  UIViewControllerExtension.swift
//  Test
//
//  Created by Ubaid ur Rahman on 23/03/2019.
//  Copyright © 2019 Ubaid ur Rahman. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
extension UIViewController{
    func showLoading(){
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            SVProgressHUD.show()
        }
    }
    
    func hideLoading(){
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
        }
    }
}
