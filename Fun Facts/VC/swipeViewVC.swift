//
//  swipeViewVC.swift
//  Motivational Widget
//
//  Created by Junaid Mukadam on 13/05/21.
//

import Lottie
import UIKit

class swipeViewVC: UIViewController {
    @IBOutlet weak var swipe: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let LottiV = AnimationView()
        LottiV.frame = self.swipe.bounds
        LottiV.backgroundColor = .clear
        LottiV.animation = Animation.named("left")
        LottiV.contentMode = .scaleAspectFit
        LottiV.loopMode = .repeat(1110)
        LottiV.play()
        
        DispatchQueue.main.async {
            self.swipe.addSubview(LottiV)
        }
    }

    @IBAction func next(_ sender: Any) {
        
        dismiss(animated: false, completion: nil)
        
    }

}
