//
//  selectFontVC.swift
//  Motivational Widget
//
//  Created by Junaid Mukadam on 27/04/21.
//

import UIKit

class selectFontVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allFonts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = String(allFonts[indexPath.row])
        cell.textLabel?.font = UIFont(name: allFonts[indexPath.row], size: 16)
        cell.tintColor = tintColor
        cell.backgroundColor = appColor
        cell.textLabel?.textColor = tintColor
        cell.accessoryType = .disclosureIndicator
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserDefaults(suiteName:
                        "group.Widinfo")!.set(allFonts[indexPath.row], forKey: "font")
        
        UserDefaults.standard.setfont(value: allFonts[indexPath.row])
        
        NotificationCenter.default.post(name: NSNotification.Name("fontChange"), object: nil)
        
        //print(allFonts[indexPath.row])
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var myView: UITableView!
    
    //var allFonts = [String]()
    
    var allFonts = ["Arial","Arial-BoldItalicMT","AvenirNextCondensed-Bold","AlNile","AmericanTypewriter","Baskerville-BoldItalic","BodoniSvtyTwoOSITCTT-Bold","ChalkboardSE-Bold","TimesNewRomanPS-BoldItalicMT","GillSans","Charter-Bold","Copperplate-Bold","Cochin-Bold","DINCondensed-Bold","Montserrat-Bold","TamilSangamMN-Bold","Georgia-BoldItalic","Thonburi-Bold","TimesNewRomanPS-BoldMT","Noteworthy-Bold"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        for family in UIFont.familyNames {
            
            for font in UIFont.fontNames(forFamilyName: family) {
                if font.contains("-Bold"){
                    
                    //allFonts.append(font)
                    
                    allFonts.sort()
                    myView.delegate = self
                    myView.dataSource = self
                    myView.reloadData()
                    
                }
            }
        }
    }
    
    
}
