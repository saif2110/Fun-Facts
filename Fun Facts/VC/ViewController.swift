//
//  ViewController.swift
//  Motivational Widget
//
//  Created by Junaid Mukadam on 25/04/21.
//

import UIKit
import WidgetKit
import SwiftUI
import CropViewController
import TOCropViewController
import InAppPurchase

class ViewController: UIViewController {
    
    @IBOutlet weak var theme: UIView!
    
    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var quoteText: UILabel!
    
    @IBOutlet weak var backgroundColour: UIButton!
    
    @IBOutlet weak var textColour: UIButton!
    
    @IBOutlet weak var font: UIButton!
    
    @IBOutlet weak var bgImage: UIButton!
    
    @IBOutlet weak var mediumWidget: UIView!
    
    
    let textSize:CGFloat = 27
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "pro"){
            bgImage.setImage(nil, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quoteText.font = UIFont(name: UserDefaults.standard.getfont(), size: textSize)
        
        quoteText.textColor = UIColor(hexString: UserDefaults.standard.gettextColor())
        mediumWidget.shadow()
        
        
        if UserDefaults.standard.isImageset(){
            let opacity = UserDefaults(suiteName: "group.Widinfo")!.object(forKey: "opacity") as? Double ?? 1
            
            let bgImage = UserDefaults(suiteName: "group.Widinfo")!.object(forKey: "bgImage") as? Data ?? Data()
            
            WhenImageisSet(image: UIImage(data: bgImage)!, opacity: Float(opacity))
        }else{
            
            WhenColorisSet(Color: UIColor(hexString: UserDefaults.standard.getbgColor())!)
        }
        
        
        mediumWidget.shadow()
        chnageAppearnceofButton(but: backgroundColour)
        chnageAppearnceofButton(but: textColour)
        chnageAppearnceofButton(but: bgImage)
        chnageAppearnceofButton(but: font)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fontChange),
                                               name: NSNotification.Name("fontChange"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeSelect),
                                               name: NSNotification.Name("themeSelect"),
                                               object: nil)
        
        
        
    }
    
    @objc func fontChange()  {
        DispatchQueue.main.async {
            self.quoteText.font = UIFont(name: UserDefaults.standard.getfont(), size: self.textSize)
        }
    }
    
    @objc func TypeVCfun()  {
        DispatchQueue.main.async {
            let vc = TypeVC()
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func themeSelect()  {
        DispatchQueue.main.async {
            let opacity = UserDefaults(suiteName: "group.Widinfo")!.object(forKey: "opacity") as? Double ?? 1
            
            let bgImage = UserDefaults(suiteName: "group.Widinfo")!.object(forKey: "bgImage") as? Data ?? Data()
            
            self.WhenImageisSet(image: UIImage(data: bgImage)!, opacity: Float(opacity))
            self.quoteText.font = UIFont(name: UserDefaults.standard.getfont(), size: self.textSize)
            self.quoteText.textColor = UIColor.init(hexString: UserDefaults.standard.gettextColor())
        }
    }
    
    func chnageAppearnceofButton(but:UIButton) {
        but.setTitleColor(tintColor, for: .normal)
        but.tintColor = tintColor
        but.layer.borderColor = tintColor.cgColor
        but.layer.borderWidth = 1.5
        but.layer.cornerRadius = 10
        
        theme.layer.borderWidth = 1.5
        theme.layer.cornerRadius = 10
        theme.layer.borderColor = tintColor.cgColor
    }
    
    var colorPickerselectedforBackground = true
    
    @IBAction func bgcolor(_ sender: Any) {
        
        colorPickerselectedforBackground = true
        
        let picker = UIColorPickerViewController()
        picker.selectedColor = .white
        picker.view.backgroundColor = appColor
        picker.view.tintColor = appColor
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func quoteButton(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func textClr(_ sender: Any) {
        colorPickerselectedforBackground = false
        let picker = UIColorPickerViewController()
        picker.selectedColor = .white
        picker.view.backgroundColor = appColor
        picker.view.tintColor = appColor
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func fontAction(_ sender: Any) {
        let vc = selectFontVC()
        present(vc, animated: true, completion: nil)
    }
    
    
    var pickerController = UIImagePickerController()
    @IBAction func bgImage(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "pro"){
            pickerController.delegate = self
            pickerController.allowsEditing = false
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true)
        }else{
          let vc = InAppViewController()
          vc.modalPresentationStyle = .fullScreen
          present(vc, animated: true, completion: nil)
        }
    }
    
}

extension ViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        
        
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        
        print(viewController.selectedColor.htmlRGBaColor)
        
        if colorPickerselectedforBackground {
            
            WhenColorisSet(Color: viewController.selectedColor)
            
        }else{
            
            UserDefaults.standard.settextColor(value: viewController.selectedColor.htmlRGBaColor)
            self.quoteText.textColor = viewController.selectedColor
            
            UserDefaults(suiteName:
                            "group.Widinfo")!.set(viewController.selectedColor.htmlRGBaColor, forKey: "textColor")
        }
    }
    
    
    func WhenImageisSet(image:UIImage,opacity:Float){
        
        UserDefaults(suiteName:
                        "group.Widinfo")!.set(image.jpegData(compressionQuality:1), forKey: "bgImage")
        
        UserDefaults(suiteName:
                        "group.Widinfo")!.set(opacity, forKey: "opacity")
        
        UserDefaults.standard.setisImageset(value: true)
        
        UserDefaults(suiteName:
                        "group.Widinfo")!.set(UIColor.black.htmlRGBaColor, forKey: "bgColor")
        
        mediumWidget.backgroundColor = .black
        imageV.image = image
        imageV.layer.backgroundColor = UIColor.black.cgColor
        imageV.layer.opacity = opacity
        
    }
    
    
    func WhenColorisSet(Color:UIColor) {
        
        self.mediumWidget.backgroundColor = Color
        
        UserDefaults.standard.setbgColor(value: Color.htmlRGBaColor)
        UserDefaults.standard.setisImageset(value: false)
        UserDefaults(suiteName:
                        "group.Widinfo")!.set(Color.htmlRGBaColor, forKey: "bgColor")
        
        UserDefaults(suiteName:
                        "group.Widinfo")!.set(UIImage(imageLiteralResourceName: "null").pngData(), forKey: "bgImage")
        UserDefaults(suiteName:
                        "group.Widinfo")!.set(0, forKey: "opacity")
        
        imageV.image = #imageLiteral(resourceName: "null")
        imageV.layer.backgroundColor = .none
        imageV.layer.opacity = 0
        
    }
    
}


extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate,TOCropViewControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            print(pickedImage.size.width , pickedImage.size.height)
            
            var width = pickedImage.size.width
            var height = pickedImage.size.height
            
            while width > 250 {
                width = width/1.2
                height = height/1.2
            }
            
            print(width,height)
            
            dismiss(animated: true, completion: nil)
            let cropVC = TOCropViewController(image: pickedImage.imageResized(to: CGSize(width: width, height: height)))
            cropVC.delegate = self
            cropVC.aspectRatioPickerButtonHidden = true
            cropVC.aspectRatioPreset = .preset5x3
            //640x300
            //cropVC.imageCropFrame = CGRect(x: 0, y: 0, width: 640, height: 350)
            cropVC.aspectRatioLockEnabled = true
            cropVC.resetAspectRatioEnabled = false
            self.present(cropVC, animated: true, completion: nil)
        }
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        
        self.WhenImageisSet(image: image, opacity: 1)
        
        dismiss(animated: true, completion: nil)
    }
    
}

