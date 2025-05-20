//
//  GroupRequestsTableViewCell.swift
//  Budget_Caddie
//
//  Created by Sabin on 10/02/25.
//

import UIKit

class GroupRequestsTableViewCell: UITableViewCell {

    @IBOutlet weak var requestDateLbl: UILabel!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var acceptButton: CustomButton!
    @IBOutlet weak var requestGroupLbl: UILabel!
    @IBOutlet weak var reqesterNameLbl: UILabel!
    @IBOutlet weak var userFaceImage: UIImageView!
    @IBOutlet weak var mainContentView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        userFaceImage.layer.cornerRadius = userFaceImage.frame.height/2
        userFaceImage.layer.borderColor = UIColor.clear.cgColor
        userFaceImage.layer.borderWidth = 1
        Utils.shared.setupCornerRadius(for: mainContentView, borderWidth: 0.2)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
