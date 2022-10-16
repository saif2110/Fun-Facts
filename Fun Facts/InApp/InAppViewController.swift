//
//  InAppPurchases.swift
//  Blood Oxygen Level App
//
//  Created by Junaid Mukadam on 19/06/21.
//

import UIKit
import Purchases
import SafariServices

enum IPA:String {
  case OneWeekPro = "FactsOneYearProNew"
  case OneYearPro = "FactPro"
} 

class InAppViewController: UIViewController {
  @IBOutlet weak var priceLabel: UILabel!
  
  var selectedIPA = 0
  
  var AllPackage = [Purchases.Package]()
  
  
  @IBOutlet weak var continueOutlet: UIButton!{
    didSet{
      continueOutlet.clipsToBounds = true
      continueOutlet.layer.cornerRadius = continueOutlet.bounds.height/2
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    Purchases.shared.offerings { (offerings, error) in
      
      if let offerings = offerings {
        
        guard let package = offerings[IPA.OneYearPro.rawValue]?.availablePackages.first else {
          return
        }
        
        guard let package2 = offerings[IPA.OneWeekPro.rawValue]?.availablePackages.first else {
          return
        }
        
        self.AllPackage.append(package2)
        self.AllPackage.append(package)
        
        let priceone = offerings[IPA.OneWeekPro.rawValue]?.annual?.localizedPriceString
        
        let pricetwo = offerings[IPA.OneYearPro.rawValue]?.lifetime?.localizedPriceString

        self.priceLabel.text = "After free trial, \(String(describing: priceone ?? "")) billed yearly. Cancel anytime."
        
        //self.YearLowerLabel.text = pricetwo
        //self.PriceMessage(price: pricetwo ?? "$5.49", save: "Save 26%")
        
        stopIndicator()
        
      }
    }
    
  }
  
  var weekBool = true
  
  
  override func viewDidAppear(_ animated: Bool) {
    backButtonoutlet.fadeIn()
    continueOutlet.clipsToBounds = true
    continueOutlet.layer.cornerRadius = continueOutlet.bounds.height/2
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
      SKStoreReviewController.requestReview(in: scene)
    }
  }
  
  func PriceMessage(price:String,save:String) -> NSAttributedString {
    let attrString = NSMutableAttributedString(string: price+"\n",
                                               attributes: [NSAttributedString.Key.font: UIFont(name: "Arial-BoldMT", size: 18)!]);
    
    attrString.append(NSMutableAttributedString(string: save,
                                                attributes: [NSAttributedString.Key.font: UIFont(name: "ArialMT", size: 10)!]))
    return attrString
  }
  
  func select(vw:UIView){
    vw.layer.borderWidth = 2
    vw.layer.borderColor = #colorLiteral(red: 0.4622848034, green: 0.8205576539, blue: 0.7943418622, alpha: 1)
  }
  
  func Deselect(vw:UIView){
    vw.layer.borderWidth = 0
    vw.layer.borderColor = UIColor.clear.cgColor
  }
  
  
  func customView(vw:UIView){
    vw.layer.cornerRadius = 10
    vw.shadow2()
  }
  
  func customLabelBanner(vw:UILabel){
    vw.layer.masksToBounds = true
    vw.layer.cornerRadius = 10
    vw.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
  }
  
  func upperView(vw:UIView){
    vw.layer.masksToBounds = true
    vw.layer.cornerRadius = 10
    vw.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }
  
  
  @IBAction func continueAction (_ sender: Any) {
    if AllPackage.count > 0 {
      startIndicator(selfo: self, UIView: self.view)
      Purchases.shared.purchasePackage(AllPackage[selectedIPA]) { (transaction, purchaserInfo, error, userCancelled) in
        if purchaserInfo?.entitlements.all[IPA.OneYearPro.rawValue]?.isActive == true || purchaserInfo?.entitlements.all[IPA.OneWeekPro.rawValue]?.isActive == true {
          
          
          self.PerchesedComplte()
          
        }else{
          
          stopIndicator()
          
        }
        
        
        print(error)
      }
      
    }
    
    
  }
  
  
  func PerchesedComplte(){
    
    stopIndicator()
    
    UserDefaults.standard.setValue(true , forKeyPath: "pro")
    UserDefaults(suiteName:
                  "group.Widinfo")!.set(true, forKey: "pro")
    
    self.present(myAlt(titel:"Congratulations !",message:"You are a pro member now. Enjoy seamless experience with all features unlock."), animated: true, completion: nil)
  }
  
  @IBAction func restore(_ sender: Any) {
    
    Purchases.shared.restoreTransactions { (purchaserInfo, error) in
      
      if purchaserInfo?.entitlements.all[IPA.OneYearPro.rawValue]?.isActive == true ||  purchaserInfo?.entitlements.all[IPA.OneWeekPro.rawValue]?.isActive == true {
        
        
        self.PerchesedComplte()
        
      }
    }
    
  }
  
  
  @IBOutlet weak var backButtonoutlet:UIButton!
  
  @IBAction func back(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func toc(sender:UIButton){
    let url = URL(string: "https://apps15.com/termsofuse.html")
    let vc = SFSafariViewController(url: url!)
    present(vc, animated: true, completion: nil)
  }
  
  @IBAction func privacyPolicy(sender:UIButton){
    let url = URL(string: "https://apps15.com/privacy.html")
    let vc = SFSafariViewController(url: url!)
    present(vc, animated: true, completion: nil)
  }
  
}


extension UIView {
  func fadeIn(duration: TimeInterval = 1.4, delay: TimeInterval = 0.9, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
    self.alpha = 0.0
    
    UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
      self.isHidden = false
      self.alpha = 1.0
    }, completion: completion)
  }
}


extension UIView {
  
  func shadow2()  {
    self.layer.shadowColor = UIColor.gray.cgColor
    self.layer.shadowOpacity = 0.4
    self.layer.shadowOffset = CGSize.zero
    self.layer.shadowRadius = 5
  }
}




//https://fluffy.es/scrollview-storyboard-xcode-11/


//Add a UIScrollView to the view and add top, bottom, leading, and trailing constraints.
//Add a UIView to the scroll view. We will call this the content view.
//Add top, bottom, leading, and trailing constraints from the content view to the scroll view's Content Layout Guide. Set the constraints to 0.
//Add an equal width constraint between the content view and the scroll view's Frame Layout Guide. (Not the scroll view or the main view!)
//Temporarily add a height constraint to the content view so that you can add your content. Make sure that all content has top, bottom, leading, and trailing constraints.
//Delete the height constraint on the content view.
