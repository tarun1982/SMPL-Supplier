//
//  ActivityIndicator.swift
//  PinterestApplication
//
//  Created by Mihir Vyas on 01/10/20.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import Foundation
import UIKit

extension UIView{

func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
    let backgroundView = UIView()
    backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    backgroundView.backgroundColor = backgroundColor
    backgroundView.tag = 475647

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
    activityIndicator.center = self.center
    activityIndicator.hidesWhenStopped = true
    if #available(iOS 13.0, *) {
        activityIndicator.style = UIActivityIndicatorView.Style.large
    } else {
        // Fallback on earlier versions
        activityIndicator.style = UIActivityIndicatorView.Style.gray
    }
    activityIndicator.color = activityColor
    activityIndicator.startAnimating()
    self.isUserInteractionEnabled = false

    backgroundView.addSubview(activityIndicator)

    self.addSubview(backgroundView)
}

func activityStopAnimating() {
    if let background = viewWithTag(475647){
        background.removeFromSuperview()
    }
    self.isUserInteractionEnabled = true
}
}


extension UIView {
    func EmptyData(textcolor: UIColor) {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: 400, height: 400)
        
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = 4756476
        var EmptyLabel: UILabel = UILabel()
        EmptyLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: 200, height: 200))
        EmptyLabel.center = self.center
        EmptyLabel.textAlignment = .center
        EmptyLabel.textColor = textcolor
        EmptyLabel.font = UIFont(name: "Avenir-Light", size: 20)
        EmptyLabel.text = "No Data Found"
        backgroundView.addSubview(EmptyLabel)
        self.addSubview(backgroundView)
    }
}

