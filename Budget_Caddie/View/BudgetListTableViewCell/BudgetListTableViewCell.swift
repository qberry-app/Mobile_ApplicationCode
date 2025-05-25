//
//  BudgetListTableViewCell.swift
//  Budget_Caddie
//
//  Created by Sabin on 28/12/24.
//

import UIKit
class BudgetListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var budgetTitle: UILabel!
    @IBOutlet weak var progressBarView: LinearProgressView!
    @IBOutlet weak var totalBudgetLimit: UILabel!
    @IBOutlet weak var budgetSpent: UILabel!
    @IBOutlet weak var budgetRemaing: UILabel!
    @IBOutlet weak var budgetImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addProgressbar()
        setupCornerRadius()
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
    func addProgressbar() {
        progressBarView.cornerRadius = progressBarView.frame.height / 2
        progressBarView.backgroundColorLayer = UIColor.init(red: 190/255, green: 190/255, blue: 190/255, alpha: 1.0)
        progressBarView.foregroundColor = UIColor.init(red: 10/255, green: 31/255, blue: 129/255, alpha: 1.0)
//        progressBarView.foregroundColor = UIColor.init(red: 42/155, green: 99/255, blue: 235/255, alpha: 1.0)
        progressBarView.setProgress(CGFloat(Int.random(in: 30..<100)), animated: true)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
