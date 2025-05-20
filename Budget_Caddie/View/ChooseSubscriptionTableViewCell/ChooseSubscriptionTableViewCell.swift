//
//  ChooseSubscriptionTableViewCell.swift
//  Budget_Caddie
//
//  Created by Sabin on 29/01/25.
//

import UIKit

class ChooseSubscriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainCustomView: UIView!
    @IBOutlet weak var cancelAnytimeLabel: UILabel!
    @IBOutlet weak var billingLabel: UILabel!
    @IBOutlet weak var trialPeriodLabel: UILabel!
    @IBOutlet weak var subscriptionPriceLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var subscriptionCheckBox: BEMCheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Utils.shared.setupCornerRadius(for: mainCustomView, borderWidth: 0.2)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
