//
//  AddTransactionTableViewCell.swift
//  Budget_Caddie
//
//  Created by Sabin on 28/12/24.
//

import UIKit

class AddTransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var deleteTransactionView: UIView!
    @IBOutlet weak var deleteTransactionButton: UIButton!
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var expenseCategoryTextField: UITextField!
    @IBOutlet weak var expenseCategoryButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupCornerRadius()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func setupCornerRadius() {
            // Add corner radius to the contentView
        mainContentView.layer.cornerRadius = 10
        mainContentView.layer.masksToBounds = true
        mainContentView.layer.borderColor = UIColor.lightGray.cgColor
//        mainContentView.layer.borderWidth = 0.5
            // Optional: Add a shadow if needed
        self.mainContentView.layer.cornerRadius = 10
        self.mainContentView.layer.masksToBounds = false
        self.mainContentView.layer.shadowColor = UIColor.black.cgColor
        self.mainContentView.layer.shadowOpacity = 0.1
        self.mainContentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.mainContentView.layer.shadowRadius = 4
        }
}
