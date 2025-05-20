//
//  GoalsTrackerTableViewCell.swift
//  Budget_Caddie
//
//  Created by Sabin on 29/12/24.
//

import UIKit

class GoalsTrackerTableViewCell: UITableViewCell {

    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var goalShortFallAmount: UILabel!
    @IBOutlet weak var goalTargetValue: UILabel!
    @IBOutlet weak var currentGoalValue: UILabel!
    @IBOutlet weak var goalProgressView: LinearProgressView!
    @IBOutlet weak var goalAchievedPercentage: UILabel!
    @IBOutlet weak var goalTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateProgressBar()
        Utils.shared.setupCornerRadius(for: mainContentView, borderWidth: 0.2)
    }
    func updateProgressBar() {
        goalProgressView.cornerRadius = goalProgressView.frame.height / 2
        goalProgressView.backgroundColorLayer = UIColor.init(red: 190/255, green: 190/255, blue: 190/255, alpha: 1.0)
        goalProgressView.foregroundColor = UIColor.init(red: 10/255, green: 31/255, blue: 129/255, alpha: 1.0)
        goalProgressView.setProgress(CGFloat(Int.random(in: 30..<100)), animated: true)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
