//
//  UserDef.swift
//  EVV
//
//  Created by Abhisar Bhatnagar on 20/11/19.
//  Copyright © 2019 Saif Mukadam. All rights reserved.
//

import Foundation
import UIKit

enum UserDefaultsKeys : String {
    case isWelcomeDone
    case id
    
    case font
    case bgColor
    case textColor
    case isImageset
    case timeappOpen
    
    case shareImage
}



extension UserDefaults{
    
    func setisWelcomeDone(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isWelcomeDone.rawValue)
    }
    func isImageset()-> Bool {
        return bool(forKey: UserDefaultsKeys.isImageset.rawValue)
    }
    
    func setisImageset(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isImageset.rawValue)
    }
    func isWelcomeDone()-> Bool {
        return bool(forKey: UserDefaultsKeys.isWelcomeDone.rawValue)
    }
    
    func setid(value: String){
        set(value, forKey: UserDefaultsKeys.id.rawValue)
    }
    func getid() -> String{
        return string(forKey: UserDefaultsKeys.id.rawValue) ?? "123"
    }
    
    func setfont(value: String){
        set(value, forKey: UserDefaultsKeys.font.rawValue)
    }
    func getfont() -> String{
        return string(forKey: UserDefaultsKeys.font.rawValue) ?? "Charter-Bold"
    }
    
    func setbgColor(value: String){
        set(value, forKey: UserDefaultsKeys.bgColor.rawValue)
    }
    func getbgColor() -> String{
        return string(forKey: UserDefaultsKeys.bgColor.rawValue) ?? "#F4F4F4F4"
    }
    
    func settextColor(value: String){
        set(value, forKey: UserDefaultsKeys.textColor.rawValue)
    }
    func gettextColor() -> String{
        return string(forKey: UserDefaultsKeys.textColor.rawValue) ?? "#000000ff"
    }
    
    
    func setshareImage(value: Data){
        set(value, forKey: UserDefaultsKeys.shareImage.rawValue)
    }
    
    func getshareImage() -> Data{
        return data(forKey: UserDefaultsKeys.shareImage.rawValue) ?? #imageLiteral(resourceName: "mountain").jpegData(compressionQuality: 1)!
    }
    
    
    func timeappOpenSet(value: Int) {
        set(value, forKey: UserDefaultsKeys.timeappOpen.rawValue)
    }
    func timeappOpen()-> Int {
        return integer(forKey: UserDefaultsKeys.timeappOpen.rawValue)
    }
    

    
}
