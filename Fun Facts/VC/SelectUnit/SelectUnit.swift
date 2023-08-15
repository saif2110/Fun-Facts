//
//  TypeVC.swift
//  Motivational Widget
//
//  Created by Junaid Mukadam on 25/04/21.
//

import UIKit
import AppTrackingTransparency

class SelectUnit: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        type.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectType", for: indexPath) as! selectType
      
        
        cell.typeTXT.text = type[indexPath.item]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space)
        return CGSize(width: size, height: 65)
    }
    
    
    var selectdType = [String]()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! selectType
      
       
        
        bounce(cell: cell)
        
        if cell.blueView.backgroundColor == tintColor {
            deSelect(cell: cell)
        }else{
            select(cell:cell)
        }
    }
    
    func select(cell:selectType) {
        resetAll()
        cell.typeTXT.textColor = .white
        cell.imageVIew.tintColor = .white
        cell.blueView.backgroundColor = tintColor
        //cell.blueView.layer.borderColor = tintColor.cgColor
        
        selectdType.append(cell.typeTXT.text!)
        if selectdType.count > 0{
            getStartedOutlet.isEnabled = true
            
           
        }
    }
    
    func deSelect(cell:selectType) {
        cell.typeTXT.textColor = UIColor.white
        cell.imageVIew.tintColor = UIColor.white
        cell.blueView.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        //cell.blueView.layer.borderColor = UIColor.white.cgColor
        
        selectdType.removeAll { $0 == cell.typeTXT.text! }
        if selectdType.count < 3{
            getStartedOutlet.isEnabled = false
            
            getStartedOutlet.setTitle("SELECT UNIT", for: .normal)
            
        }
    }
    
    func resetAll(){
        for cellView in collectionView.visibleCells {
           let cell  = cellView as? selectType
            deSelect(cell: cell!)
        }
    }
    
    func bounce(cell:selectType){
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            
            // HERE
            cell.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2) // Scale your image
            
        }) { (finished) in
            UIView.animate(withDuration: 0.1, animations: {
                
                cell.transform = CGAffineTransform.identity // undo in 1 seconds
                
            })
        }
    }
    
    
    
    @IBOutlet weak var getStartedOutlet: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var type = ["Fun","Study","Entertainment","Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getStartedOutlet.isEnabled = false
       
        getStartedOutlet.setTitleColor(UIColor.white, for: .normal)
        
        getStartedOutlet.setTitle("CONTINUE", for: .normal)
        
        self.collectionView.register(UINib(nibName: "selectType", bundle: nil), forCellWithReuseIdentifier: "selectType")
        
        
        //startIndicator(selfo: self, UIView: self.collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    @IBAction func getStarted(_ sender: Any) {
        
        
        
        self.dismiss(animated: false) {
            
            DispatchQueue.main.async {
                if let topMostViewController = UIApplication.getTopViewController() {
                    openInappPerchase(context: topMostViewController)
                }
            }
            
        }
        
        
        
    }
    
}


extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
