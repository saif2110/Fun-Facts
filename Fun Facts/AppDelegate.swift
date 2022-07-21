//
//  AppDelegate.swift
//  Fun Facts
//
//  Created by Junaid Mukadam on 14/05/21.
//

import UIKit
import WidgetKit
import GoogleMobileAds
import InAppPurchase


let tintColor2 = #colorLiteral(red: 0.4919828773, green: 0.9111565948, blue: 0.5098821521, alpha: 1)
let appColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
let tintColor = #colorLiteral(red: 0.3019607843, green: 0.8509803922, blue: 0.8705882353, alpha: 1)

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.tintColor = tintColor
        
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["6210b868cd886cacae0f1cd1ed3f41b3"]
        
        let iap = InAppPurchase.default
        iap.addTransactionObserver(fallbackHandler: {_ in
            // Handle the result of payment added by Store
            // See also `InAppPurchase#purchase`

            //print("what the hell is this")
        })
        
        UserDefaults.standard.timeappOpenSet(value: UserDefaults.standard.timeappOpen() + 1)
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
}

