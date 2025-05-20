//
//  BudgetAdjustmentTableViewCell.swift
//  Budget_Caddie
//
//  Created by Sabin on 28/12/24.
//

import UIKit

class BudgetAdjustmentTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryStepper: GMStepper!
    @IBOutlet weak var categoryTitle: UILabel!
    
    @IBOutlet weak var mainContentView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupCornerRadius()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func setupStepper() {
        categoryStepper.minimumValue = 0
        categoryStepper.maximumValue = 5000
        categoryStepper.stepValue = 1
//        categoryStepper.leftButton.backgroundColor = UIColor.init(red: 10/255, green: 31/255, blue: 129/255, alpha: 1.0)
//        categoryStepper.rightButton.backgroundColor = UIColor.init(red: 10/255, green: 31/255, blue: 129/255, alpha: 1.0)
//        categoryStepper.label.backgroundColor = UIColor.init(red: 10/255, green: 31/255, blue: 129/255, alpha: 0.5)
        categoryStepper.textFieldFont = UIFont.systemFont(ofSize: 14)
        categoryStepper.value = Double(Int.random(in: 0..<500))
        categoryStepper.translatesAutoresizingMaskIntoConstraints = false
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
