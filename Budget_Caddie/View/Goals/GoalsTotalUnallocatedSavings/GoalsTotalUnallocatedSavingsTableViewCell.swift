//
//  GoalsTotalUnallocatedSavingsTableViewCell.swift
//  Budget_Caddie
//
//  Created by Sabin on 29/12/24.
//

import UIKit

class GoalsTotalUnallocatedSavingsTableViewCell: UITableViewCell {
    @IBOutlet weak var unallocatedFundTitle: UILabel!
    
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var savingsDescription: UILabel!
    @IBOutlet weak var savingsProgressView: LinearProgressView!
    @IBOutlet weak var unallocatedFundAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Utils.shared.setupCornerRadius(for: mainContentView, borderWidth: 0.2)
        updateProgressBar()
    }
    func updateProgressBar() {
        savingsProgressView.cornerRadius = savingsProgressView.frame.height / 2
        savingsProgressView.backgroundColorLayer = UIColor.init(red: 190/255, green: 190/255, blue: 190/255, alpha: 1.0)
        savingsProgressView.foregroundColor = UIColor.init(red: 126/255, green: 0/255, blue: 196/255, alpha: 1.0)
        savingsProgressView.setProgress(CGFloat(Int.random(in: 30..<100)), animated: true)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
