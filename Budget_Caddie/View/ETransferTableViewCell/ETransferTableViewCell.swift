//
//  ETransferTableViewCell.swift
//  Budget_Caddie
//
//  Created by Sabin on 15/01/25.
//

import UIKit

class ETransferTableViewCell: UITableViewCell {

    @IBOutlet weak var sharedBudgetButton: UIButton!
    @IBOutlet weak var categoraiseButton: UIButton!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainContentView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        Utils.shared.setupCornerRadius(for: mainContentView, borderWidth: 0.2)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
