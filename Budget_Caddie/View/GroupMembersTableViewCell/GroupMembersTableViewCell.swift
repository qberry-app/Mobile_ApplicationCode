//
//  GroupMembersTableViewCell.swift
//  Budget_Caddie
//
//  Created by Sabin on 10/02/25.
//

import UIKit

class GroupMembersTableViewCell: UITableViewCell {

    @IBOutlet weak var nextNavigationButton: UIButton!
    @IBOutlet weak var groupUserTitle: UILabel!
    @IBOutlet weak var groupUserName: UILabel!
    @IBOutlet weak var groupUserImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.groupUserImage.layer.cornerRadius = self.groupUserImage.bounds.size.width / 2.0
          self.groupUserImage.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
