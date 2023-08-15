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
import Purchases
import FirebaseCore
import SuperwallKit


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
      
      Superwall.configure(apiKey: "pk_757c2dcd4ac6e45c223a8ccafc0eab87d2c39862a0d2ef2e")
      Purchases.debugLogsEnabled = false
      Purchases.configure(withAPIKey: "appl_ozycjglBHBHaaReiTiXorPQszMg")
      isSubsActive()
      
      
        UserDefaults.standard.timeappOpenSet(value: UserDefaults.standard.timeappOpen() + 1)
        
      FirebaseApp.configure()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        WidgetCenter.shared.reloadAllTimelines()
    }
  
  
  
  func isSubsActive(){
      
      Purchases.shared.purchaserInfo { (purchaserInfo, error) in
          
          if purchaserInfo?.entitlements.all[IPA.OneWeekPro.rawValue]?.isActive == true ||
              purchaserInfo?.entitlements.all[IPA.OneYearPro.rawValue]?.isActive == true  {
              
            UserDefaults.standard.setValue(true , forKeyPath: "pro")
            UserDefaults(suiteName:
                            "group.Widinfo")!.set(true, forKey: "pro")
              
          }else{
              
            UserDefaults.standard.setValue(false , forKeyPath: "pro")
            UserDefaults(suiteName:
                            "group.Widinfo")!.set(false, forKey: "pro")

          }
      }
  }
  
  
    
}


func openInappPerchase(context:UIViewController){
//  let vc = InAppViewController()
//  vc.modalPresentationStyle = .fullScreen
//  context.present(vc, animated: false, completion: nil)
  Superwall.shared.register(event: "campaign_trigger")
}
