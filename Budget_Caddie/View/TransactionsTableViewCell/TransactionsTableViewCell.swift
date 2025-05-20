//
//  TransactionsTableViewCell.swift
//  Budget_Caddie
//
//  Created by Sabin on 28/12/24.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryName: UILabel!
    
    @IBOutlet weak var transactionDate: UILabel!
    @IBOutlet weak var transactionDescription: UILabel!
    @IBOutlet weak var transactionAmount: UILabel!
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
