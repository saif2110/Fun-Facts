//
//  Theme.swift
//  Motivational Widget
//
//  Created by Junaid Mukadam on 28/04/21.
//

import UIKit

class Theme: UITableViewCell {

    @IBOutlet weak var proCrown: UIImageView!

    @IBOutlet weak var Bgimage: UIImageView!
    
    @IBOutlet weak var outerView: UIView!
    
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        outerView.layer.cornerRadius = 20
        //outerView.shadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
