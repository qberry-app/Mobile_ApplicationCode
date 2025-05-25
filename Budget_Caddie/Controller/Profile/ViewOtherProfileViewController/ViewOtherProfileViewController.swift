//
//  ViewOtherProfileViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 19/01/25.
//

import UIKit

class ViewOtherProfileViewController: UIViewController {

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var addFriendsBtn: CustomButton!
    @IBOutlet weak var aboutDescriptionLbl: UILabel!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var medalImage: UIImageView!
    @IBOutlet weak var medalNameLbl: UILabel!
    @IBOutlet weak var joinedDateLbl: UILabel!
    @IBOutlet weak var useridLbl: UILabel!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var userProfilePic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didClickAddFriendsBtn(_ sender: UIButton) {
        
    }
    @IBAction func didClickShare(_ sender: UIButton) {
        
    }
    
    @IBAction func didClickBackButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

}
