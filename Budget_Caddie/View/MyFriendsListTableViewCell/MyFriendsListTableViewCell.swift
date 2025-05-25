//
//  MyFriendsListTableViewCell.swift
//  Budget_Caddie
//
//  Created by Sabin on 19/01/25.
//

import UIKit

class MyFriendsListTableViewCell: UITableViewCell {

    @IBOutlet weak var userBadgeImage: UIImageView!
    @IBOutlet weak var userBadgeLbl: UILabel!
    @IBOutlet weak var useridLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
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
