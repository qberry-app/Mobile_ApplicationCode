//
//  FriendsRequestTableViewCell.swift
//  Budget_Caddie
//
//  Created by Sabin on 31/01/25.
//

import UIKit

class FriendsRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var acceptButton: CustomButton!
    @IBOutlet weak var userBadgeImageView: UIImageView!
    @IBOutlet weak var userTitleLbl: UILabel!
    @IBOutlet weak var userIdLbl: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.layer.borderColor = UIColor.clear.cgColor
        userImageView.layer.borderWidth = 1
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
