//
//  ProfileCardListTableViewCell.swift
//  Budget_Caddie
//
//  Created by Sabin on 30/12/24.
//

import UIKit

class ProfileCardListTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var sideButtonClicked: UIButton!
    @IBOutlet weak var cardNameNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
