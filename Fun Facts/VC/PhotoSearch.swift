//
//  PhotoSearch.swift
//  Motivational Widget
//
//  Created by Junaid Mukadam on 29/04/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class PhotoSearch: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! imageCell
        
        cell.photo.kf.indicatorType = .activity
        
        cell.photo.kf.setImage(with: URL(string: photos[indexPath.row]))
        
        return cell
    }
    
    @IBOutlet weak var myView: UICollectionView!
    var photos = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAds(Myself: self)
        
        api()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! imageCell
        if let image = cell.photo.image?.jpegData(compressionQuality: 1){
            UserDefaults.standard.setshareImage(value: image)
            NotificationCenter.default.post(name: NSNotification.Name("photoChange"), object: nil)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    func api(search:String = "nature"){
        photos.removeAll()
        //startIndicator(selfo: self, UIView: self.myView)
        let url = baseUrl +  "factsBG.php"
        
        let header : HTTPHeaders = ["Content-Type":"application/json","Authorization":"563492ad6f917000010000019ac3513701644511af300d7789fc759a"]
        
        AF.request(url,method:.get,encoding: JSONEncoding.default,headers:header).responseJSON {
            response in
            switch(response.result){
            case .success(_:):
                let json = JSON(response.data!)
                
                for (_,subJson) in json["types"] {
                    self.photos.append(subJson.string ?? "")
                }
                
                //stopIndicator()
                self.myView.delegate = self
                self.myView.dataSource = self
                self.myView.reloadData()
                
                break
            case .failure(_:):
                
                break
            }
        }
    }
    
    
}

extension PhotoSearch : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 3.0
        return CGSize(width: size, height: size + 50)
    }
}
