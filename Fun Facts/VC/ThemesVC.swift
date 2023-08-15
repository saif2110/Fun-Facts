//
//  ThemesVC.swift
//  Motivational Widget
//
//  Created by Junaid Mukadam on 28/04/21.
//

import Kingfisher
import UIKit

class ThemesVC: UIViewController {
    @IBOutlet weak var myView: UITableView!
    
    var isPro = [String]()
    var textColor = [String]()
    var image = [String]()
    var font = [String]()
    var opacity = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAds(Myself: self)
        
        startIndicator(selfo: self, UIView: self.view)
        
        postWithParameter(Url: "theme.php", parameters: [:]) { (JSON, Err) in
            
            for (_ , subJSon) in JSON["themes"]{
                 
                self.isPro.append(subJSon["isPro"].string ?? "")
                self.textColor.append(subJSon["textColor"].string ?? "")
                self.image.append(subJSon["image"].string ?? "")
                self.font.append(subJSon["font"].string ?? "")
                self.opacity.append(subJSon["opacity"].string ?? "")
            }
            
            stopIndicator()
            self.myView.delegate = self
            self.myView.dataSource = self
            self.myView.reloadData()
        }
        

        
    }


}

extension ThemesVC:UITableViewDelegate,UITableViewDataSource {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        image.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Theme", for: indexPath) as! Theme
        cell.Bgimage.backgroundColor = .black
        cell.Bgimage.layer.backgroundColor = UIColor.black.cgColor
        cell.Bgimage.layer.opacity = Float(opacity[indexPath.row]) ?? 1
        cell.Bgimage.kf.setImage(with: URL(string: image[indexPath.row]))
        cell.label.font = UIFont(name: font[indexPath.row], size: 28)
        cell.label?.textColor = UIColor.init(hexString: textColor[indexPath.row])
        
        if isPro[indexPath.row] == "free"{
            cell.proCrown.isHidden = true
        }else{
            cell.proCrown.isHidden = false
        }

        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
 
      
        if UserDefaults.standard.bool(forKey: "pro") {
        
        let cell = tableView.cellForRow(at: indexPath) as! Theme

        WhenImageisSet(image: cell.Bgimage.image!, opacity: Float(opacity[indexPath.row])!)

        UserDefaults(suiteName:
                        "group.Widinfo")!.set(font[indexPath.row], forKey: "font")

        UserDefaults.standard.setfont(value: font[indexPath.row])

        UserDefaults.standard.settextColor(value:textColor[indexPath.row])

        UserDefaults(suiteName:
                        "group.Widinfo")!.set(textColor[indexPath.row], forKey: "textColor")

        NotificationCenter.default.post(name: NSNotification.Name("fontChange"), object: nil)

        NotificationCenter.default.post(name: NSNotification.Name("themeSelect"), object: nil)

        }else if isPro[indexPath.row] == "free" {
            
            let cell = tableView.cellForRow(at: indexPath) as! Theme
            
            WhenImageisSet(image: cell.Bgimage.image!, opacity: Float(opacity[indexPath.row])!)
            
            UserDefaults(suiteName:
                            "group.Widinfo")!.set(font[indexPath.row], forKey: "font")
            
            UserDefaults.standard.setfont(value: font[indexPath.row])
            
            UserDefaults.standard.settextColor(value:textColor[indexPath.row])
            
            UserDefaults(suiteName:
                            "group.Widinfo")!.set(textColor[indexPath.row], forKey: "textColor")
            
            NotificationCenter.default.post(name: NSNotification.Name("fontChange"), object: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name("themeSelect"), object: nil)
            
        }else{
            
          openInappPerchase(context: self)
            
        }
    }
    
    func WhenImageisSet(image:UIImage,opacity:Float){
        
        UserDefaults(suiteName:
                        "group.Widinfo")!.set(image.jpegData(compressionQuality: 1), forKey: "bgImage")
        
        UserDefaults(suiteName:
                        "group.Widinfo")!.set(opacity, forKey: "opacity")
        
        UserDefaults.standard.setisImageset(value: true)
        
        UserDefaults(suiteName:
                        "group.Widinfo")!.set(UIColor.black.htmlRGBaColor, forKey: "bgColor")
        
        dismiss(animated: true, completion: nil)
    }

}
