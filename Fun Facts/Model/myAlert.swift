//
//  myAlert.swift
//  Created by Junaid Mukadam on 09/12/18.
//

import Foundation
import UIKit

func myAlt(titel:String,message:String)-> UIAlertController{
    let alert = UIAlertController(title: titel, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        switch action.style{
        case .default:
            print("")
        case .cancel:
            print("")
        case .destructive:
            print("")
        @unknown default:
            fatalError()
        }}))
                 
    return alert
    
}

//copy paste this

//self.present(myAlt(titel:"Failure",message:"Something went wrong."), animated: true, completion: nil)


var indicator = UIActivityIndicatorView()

func startIndicator(selfo:UIViewController,UIView:UIView) {
    indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    indicator.color = tintColor
    UIView.addSubview(indicator)
    indicator.center = CGPoint(x: UIView.frame.size.width / 2.0, y: (UIView.frame.size.height) / 2.0)
    indicator.startAnimating()
}


func stopIndicator() {
    indicator.stopAnimating()
}


extension UIView {
    func shadow()  {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
    }
}
