//
//  OnBoardingTableViewCell.swift
//  Budget_Caddie
//
//  Created by Sabin on 17/02/25.
//

import UIKit

class OnBoardingTableViewCell: UITableViewCell {

    @IBOutlet weak var contentSelectionImage: UIImageView!
    @IBOutlet weak var contentText: UILabel!
    
    @IBOutlet weak var mainContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        mainContentView.addDropShadow()
        Utils.shared.setupCornerRadius(for: mainContentView, borderWidth: 0.2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
