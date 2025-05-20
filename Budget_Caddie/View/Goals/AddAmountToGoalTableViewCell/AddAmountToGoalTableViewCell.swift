//
//  AddAmountToGoalTableViewCell.swift
//  Budget_Caddie
//
//  Created by Sabin on 29/12/24.
//

import UIKit

class AddAmountToGoalTableViewCell: UITableViewCell {

    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var addUnallocatedSavingButton: UIButton!
    @IBOutlet weak var unallocatedSavingAmount: UITextField!
    @IBOutlet weak var unallocatedSavingTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Utils.shared.setupCornerRadius(for: mainContentView, borderWidth: 0.2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
