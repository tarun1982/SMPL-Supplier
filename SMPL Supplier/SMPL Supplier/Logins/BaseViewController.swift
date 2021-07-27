//
//  BaseViewController.swift
//  SMPL Supplier
//
//  Created by Family on 04/11/20.
//  Copyright © 2020 Family. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
               // Always adopt a light interface style.
               overrideUserInterfaceStyle = .light
           }
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Supporting Functions
       
       func show(alertWithTitle title:String,message:String) {
           let alert = UIAlertController(title: title,
                                         message: message,
                                         preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Ok",
                                         style: .default,
                                         handler: nil))
           self.present(alert,
                        animated: true,
                        completion: nil)
       }
       
       enum indicatorSwitch {
           case start
           case stop
       }
    
}
