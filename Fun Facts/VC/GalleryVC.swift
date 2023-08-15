//
//  GalleryVC.swift
//  Motivational Widget
//
//  Created by Junaid Mukadam on 29/04/21.
//

import UIKit
import Alamofire
import StoreKit
import InAppPurchase
import SwiftyJSON

class GalleryVC: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var pro: UIButton!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var label: UILabel!
    
    let opacity = 1
    
    var arrayofQuotes = [String]()
    
    var textSize:CGFloat = 27
    
    override func viewDidAppear(_ animated: Bool) {
        pro.shakeAnimation()
        
        
        if !Connectivity.isConnectedToInternet {
            
            let alert2 = UIAlertController(title: "Connection Error", message: "The Internet connection appears to be offline.Please connect to Internet and open the app again.", preferredStyle: .alert)
            alert2.addAction(UIAlertAction(title: "EXIT APP", style: .default, handler: { action in
                                            switch action.style{
                                            case .default:
                                                exit(0)
                                            case .cancel:
                                                print("")
                                            case .destructive:
                                                print("")
                                            @unknown default:
                                                fatalError()
                                            }}))
            
            present(alert2, animated: true, completion: nil)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        label.font = UIFont(name: UserDefaults.standard.getfont(), size: textSize)
        
        if !arrayofQuotes.isEmpty {
            setLabel(quote: arrayofQuotes[leftswiped])
        }
        
        if UserDefaults.standard.bool(forKey: "pro"){
            pro.setImage(nil, for: .normal)
            pro.setTitle("YOU PRO", for: .normal)
            pro.setTitleColor(UIColor.orange, for: .normal)
            pro.isEnabled = false
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
      if UserDefaults.standard.timeappOpen() != 1 {
      if !UserDefaults.standard.bool(forKey: "pro") {
     
        DispatchQueue.main.async {

          openInappPerchase(context: self)
         
          }
        }
      }
      
        let iap = InAppPurchase.default
        iap.set(shouldAddStorePaymentHandler: { (product) -> Bool in
            return true
        }, handler: { (result) in
            switch result {
            case .success( _):
                self.PerchesedComplte()
            case .failure( _):
                print("error")
            }
        })
        
        photo.image = UIImage(data: UserDefaults.standard.getshareImage())
        photo.backgroundColor = .black
        photo.layer.opacity = Float(opacity)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(photoChange),
                                               name: NSNotification.Name("photoChange"),
                                               object: nil)
        
        hitAPI()
        
        let leftSwipe = UISwipeGestureRecognizer()
        leftSwipe.direction = .left
        mainView.addGestureRecognizer(leftSwipe)
        leftSwipe.addTarget(self, action:  #selector(leftSwiped))
        
        let rightSwipe = UISwipeGestureRecognizer()
        rightSwipe.direction = .right
        mainView.addGestureRecognizer(rightSwipe)
        rightSwipe.addTarget(self, action:  #selector(rightSwiped))
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fontChange),
                                               name: NSNotification.Name("fontChange"),
                                               object: nil)
        
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(TypeVCfun),
                                               name: NSNotification.Name("TypeVC"),
                                               object: nil)
        
        DispatchQueue.main.async {
            if !UserDefaults.standard.isWelcomeDone(){
                let vc = Welcome()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    
    var by = false
    
    func hitAPI(){
        leftswiped = 0
        arrayofQuotes.removeAll()
       // startIndicator(selfo: self, UIView: self.view)
        let type = UserDefaults(suiteName: "group.Widinfo")!.object(forKey: "type") as? Array ?? ["random"]
        
        postWithParameter(Url: "facts.php", parameters: ["type":type,"by":true]) { (JSON, Err) in
            
            if Err == nil {
                
                if self.by {
                    
                    for (_,Subjson) in JSON["quotes"]{
                        
                        self.arrayofQuotes.append(Subjson.string ?? "")
                    }
                    
                }else{
                    
                    for (_,Subjson) in JSON["quotes"]{
                        self.arrayofQuotes.append(Subjson.string ?? "")
                    }
                    
                }
                
    
                
                self.setLabel(quote: self.arrayofQuotes[0])
                
                
            }
          
            stopIndicator()
        }
      
    }
    
    func PerchesedComplte(){
        UserDefaults.standard.setValue(true , forKeyPath: "pro")
        UserDefaults(suiteName:
                        "group.Widinfo")!.set(true, forKey: "pro")
        self.present(myAlt(titel:"Congratulations !",message:"You are a pro member now. Enjoy seamless experience without the Ads."), animated: true, completion: nil)
    }
    
    @objc func fontChange(){
        label.font = UIFont(name: UserDefaults.standard.getfont(), size: textSize)
        setLabel(quote: arrayofQuotes[leftswiped])
    }
    
    @objc func photoChange(){
        photo.image = UIImage(data: UserDefaults.standard.getshareImage())
        photo.backgroundColor = .black
        photo.layer.opacity = Float(opacity)
    }
    
    
    
    
    @objc func image(_ image: UIImage,
                     didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("ERROR: \(error)")
        }
    }
    
    
    
    
    
    
    func setLabel(quote:String) {
        let fullText = quote.components(separatedBy: "|")
        
        if by {
            
            let att = NSMutableAttributedString(string: fullText[0] + "\n\n- " + fullText[1])
            
            att.setColorForText(textForAttribute: "\n\n- " + fullText[1], withColor: tintColor2)
            
            att.setFontForText(textForAttribute: "\n\n- " + fullText[1], withFont: UIFont(name: UserDefaults.standard.getfont(), size: textSize - 4)!)
            
            self.label.attributedText = att
            
        }else{
            
            self.label.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
            self.label.layer.cornerRadius = 8
            self.label.clipsToBounds = true
            self.label.setMargins(margin: 10)
            self.label.textAlignment = .center
            //let att = NSMutableAttributedString(string: fullText[0])
            self.label.text = "\n" + fullText[0] + "\n"
            //self.label.backgroundColor = .white
            
        }
        
    }
    
    
    
    @IBAction func pro(_ sender: Any) {
      openInappPerchase(context: self)
    }
    
    var leftswiped = 0
    @objc func leftSwiped(){
        next()
    }
    
    @objc func rightSwiped(){
        previous()
    }
    
    func next(){
        
        if leftswiped < 49 {
            leftswiped += 1
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            if leftswiped.isMultiple(of: 6){
                showAds(Myself: self)
            }
            
//            if leftswiped == 3 {
//                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
//                    SKStoreReviewController.requestReview(in: scene)
//                }
//            }
            
            UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseInOut, animations: {
                self.label.transform = CGAffineTransform(translationX: self.label.bounds.origin.x - 500, y: self.label.bounds.origin.y)
            }) { (Bool) in
                //self.label.text = self.arrayofQuotes[self.leftswiped]
                self.setLabel(quote: self.arrayofQuotes[self.leftswiped])
                self.label.transform = .identity
            }
            
        }
    }
    
    func previous(){
        if leftswiped > 0 {
            
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            leftswiped -= 1
            UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseInOut, animations: {
                self.label.transform = CGAffineTransform(translationX: self.label.bounds.origin.x + 500, y: self.label.bounds.origin.y)
            }) { (Bool) in
                //self.label.text = self.arrayofQuotes[self.leftswiped]
                self.setLabel(quote: self.arrayofQuotes[self.leftswiped])
                self.label.transform = .identity
            }
            
        }
    }
    
    @IBAction func copyMe(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        UIPasteboard.general.string = arrayofQuotes[leftswiped]
        label.text = "Fact Copied..."
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.label.text = self.arrayofQuotes[self.leftswiped]
        }
    }
    
    
    @IBAction func instagram(_ sender: Any) {
        
        let instagramURL = URL(string: "instagram://app")
        
        if UIApplication.shared.canOpenURL(instagramURL!) {
            
            let renderer = UIGraphicsImageRenderer(size: self.mainView.bounds.size)
            let image = renderer.image { ctx in
                self.mainView.drawHierarchy(in: self.mainView.bounds, afterScreenUpdates: true)
            }
            
            let url = URL(string: "instagram-stories://share")!
            if UIApplication.shared.canOpenURL(url){
                
                let backgroundData = image.jpegData(compressionQuality: 1)!
                let pasteBoardItems = [
                    ["com.instagram.sharedSticker.backgroundImage" : backgroundData]
                ]
                
                UIPasteboard.general.setItems(pasteBoardItems, options: [.expirationDate: Date().addingTimeInterval(60 * 5)])
                
                UIApplication.shared.open(url, completionHandler: nil)
                
            }
            
        }
        
    }
    
    var documentInteractionController = UIDocumentInteractionController()
    
    @IBAction func whatsApp(_ sender: Any) {
        let urlWhats = "whatsapp://app"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed) {
            if let whatsappURL = URL(string: urlString) {
                
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    
                    let renderer = UIGraphicsImageRenderer(size: self.mainView.bounds.size)
                    let image = renderer.image { ctx in
                        self.mainView.drawHierarchy(in: self.mainView.bounds, afterScreenUpdates: true)
                    }
                    
                    if let imageData = image.jpegData(compressionQuality: 1) {
                        let tempFile = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/whatsAppTmp.wai")
                        do {
                            try imageData.write(to: tempFile, options: .atomic)
                            self.documentInteractionController = UIDocumentInteractionController(url: tempFile)
                            self.documentInteractionController.uti = "net.whatsapp.image"
                            self.documentInteractionController.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
                            
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    print("Cannot open whatsapp")
                }
            }
        }
    }
    
    @IBAction func download(_ sender: Any) {
        let renderer = UIGraphicsImageRenderer(size: self.mainView.bounds.size)
        let image = renderer.image { ctx in
            self.mainView.drawHierarchy(in: self.mainView.bounds, afterScreenUpdates: true)
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self,
                                       #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    @IBAction func share(_ sender: Any) {
        
        let renderer = UIGraphicsImageRenderer(size: self.mainView.bounds.size)
        let image = renderer.image { ctx in
            self.mainView.drawHierarchy(in: self.mainView.bounds, afterScreenUpdates: true)
        }
        
        let imageShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @objc func TypeVCfun()  {
        DispatchQueue.main.async {
            let vc = TypeVC()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func font(_ sender: Any) {
        let vc = selectFontVC()
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func quotes(_ sender: Any) {
        let vc = TypeVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func fontSize(_ sender: Any) {
        showSimpleActionSheet(controller: self)
    }
    
    @IBAction func byWhom(_ sender: Any) {
        by.toggle()
        setLabel(quote: self.arrayofQuotes[leftswiped])
    }
    
    func showSimpleActionSheet(controller: UIViewController) {
        
        let alert = UIAlertController(title: "Select font size", message: "Please select font size for the quote", preferredStyle: .actionSheet)
        
        alert.view.tintColor = tintColor
        
        alert.addAction(UIAlertAction(title: "Small Size", style: .default, handler: { (_) in
            self.textSize = 24
            self.label.font = UIFont(name: UserDefaults.standard.getfont(), size: self.textSize)
            self.setLabel(quote: self.arrayofQuotes[self.leftswiped])
        }))
        
        alert.addAction(UIAlertAction(title: "Small+ Size", style: .default, handler: { (_) in
            self.textSize = 26
            self.label.font = UIFont(name: UserDefaults.standard.getfont(), size: self.textSize)
            self.setLabel(quote: self.arrayofQuotes[self.leftswiped])
        }))
        
        alert.addAction(UIAlertAction(title: "Default Size", style: .default, handler: { (_) in
            self.textSize = 27
            self.label.font = UIFont(name: UserDefaults.standard.getfont(), size: self.textSize)
            self.setLabel(quote: self.arrayofQuotes[self.leftswiped])
        }))
        
        alert.addAction(UIAlertAction(title: "Large Size", style: .default, handler: { (_) in
            self.textSize = 29
            self.label.font = UIFont(name: UserDefaults.standard.getfont(), size: self.textSize)
            self.setLabel(quote: self.arrayofQuotes[self.leftswiped])
        }))
        
        alert.addAction(UIAlertAction(title: "Large+ Size", style: .default, handler: { (_) in
            self.textSize = 30
            self.label.font = UIFont(name: UserDefaults.standard.getfont(), size: self.textSize)
            self.setLabel(quote: self.arrayofQuotes[self.leftswiped])
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    @IBAction func widget(_ sender: Any) {
        
        let main = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let vc = main.instantiateViewController(identifier: "ViewController") as! ViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    struct Connectivity {
        static let sharedInstance = NetworkReachabilityManager()!
        static var isConnectedToInternet:Bool {
            return self.sharedInstance.isReachable
        }
    }
    
    
}



extension UIView {
    func shakeAnimation() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.isRemovedOnCompletion = true
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 7, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 7, y: self.center.y))
        self.layer.add(animation, forKey: nil)
    }
}
