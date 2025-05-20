//
//  GoalEmergencyFundTableViewCell.swift
//  Budget_Caddie
//
//  Created by Sabin on 29/12/24.
//

import UIKit

class GoalEmergencyFundTableViewCell: UITableViewCell {

    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var shortFallLbl: UILabel!
    @IBOutlet weak var goalTargetLbl: UILabel!
    @IBOutlet weak var currentTarget: UILabel!
    @IBOutlet weak var goalProgressView: LinearProgressView!
    @IBOutlet weak var goalTitleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        Utils.shared.setupCornerRadius(for: mainContentView, borderWidth: 0.2)
        updateProgressBar()
        // Initialization code
    }
    func updateProgressBar() {
        goalProgressView.cornerRadius = goalProgressView.frame.height / 2
        goalProgressView.backgroundColorLayer = UIColor.init(red: 190/255, green: 190/255, blue: 190/255, alpha: 1.0)
        goalProgressView.foregroundColor = UIColor.init(red: 126/255, green: 0/255, blue: 196/255, alpha: 1.0)
        goalProgressView.setProgress(CGFloat(Int.random(in: 30..<100)), animated: true)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
