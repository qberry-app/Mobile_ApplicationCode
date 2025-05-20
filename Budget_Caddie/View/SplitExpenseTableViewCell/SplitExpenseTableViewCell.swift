//
//  SplitExpenseTableViewCell.swift
//  Budget_Caddie
//
//  Created by Sabin on 15/01/25.
//

import UIKit

class SplitExpenseTableViewCell: UITableViewCell {

    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var ExpenseAmountTxtFld: UITextField!
    @IBOutlet weak var deleteExpenseButton: CustomButton!
    @IBOutlet weak var expenseTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Utils.shared.setupCornerRadius(for: mainContentView,borderWidth: 0.2)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
