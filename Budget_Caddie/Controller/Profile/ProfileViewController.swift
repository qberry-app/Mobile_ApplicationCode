//
//  ProfileViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 24/12/24.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var supportContentView: UIView!
    @IBOutlet weak var bankCardsContentView: UIView!
    @IBOutlet weak var ProfileContentView: UIView!
    
    @IBOutlet weak var cardViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userProfilePic: UIImageView!
    
    @IBOutlet weak var bankCardsTableView: UITableView!
    @IBOutlet weak var userCountryLbl: UILabel!
    @IBOutlet weak var emailListContentView: UIView!
    
    @IBOutlet weak var emailListViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var emailListHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var emailListTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewArray = [ProfileContentView, bankCardsContentView, supportContentView, emailListContentView]
        for i in viewArray {
            Utils.shared.setupCornerRadius(for: i!, borderWidth: 0.2)
        }
        registerTableViewNibs()
        registerEmailTableViewNibs()
        // Do any additional setup after loading the view.
    }
    func registerTableViewNibs() {
        self.bankCardsTableView.register(UINib(nibName: "ProfileCardListTableViewCell",
                                               bundle: nil), forCellReuseIdentifier: "ProfileCardListTableViewCell")
        self.bankCardsTableView.delegate = self
        self.bankCardsTableView.dataSource = self
        self.bankCardsTableView.separatorStyle = .none
        self.bankCardsTableView.rowHeight = 62
        self.bankCardsTableView.estimatedRowHeight = 62
        self.bankCardsTableView.reloadData()
        tableHeightConstraint.constant = self.bankCardsTableView.contentSize.height
        cardViewHeightConstraint.constant = self.bankCardsTableView.contentSize.height + 132
    }
    
    func registerEmailTableViewNibs() {
        self.emailListTableView.register(UINib(nibName: "ProfileCardListTableViewCell",
                                               bundle: nil), forCellReuseIdentifier: "ProfileCardListTableViewCell")
        self.emailListTableView.delegate = self
        self.emailListTableView.dataSource = self
        self.emailListTableView.separatorStyle = .none
        self.emailListTableView.rowHeight = 62
        self.emailListTableView.estimatedRowHeight = 62
        self.emailListTableView.reloadData()
        emailListHeightConstant.constant = self.emailListTableView.contentSize.height
        emailListViewHeightConstant.constant = self.emailListTableView.contentSize.height + 132
    }
    
    @IBAction func didClickCloseProfile(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didClickEditProfileButton(_ sender: UIButton) {
        let editProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProfileVCID") as! EditProfileViewController
        editProfileVC.modalPresentationStyle = .fullScreen
        self.present(editProfileVC, animated: true)
    }
    
    @IBAction func didClickDeleteAccountButton(_ sender: UIButton) {
       
    }
    @IBAction func didClickNewCardButton(_ sender: UIButton) {
    }
    
    @IBAction func didClickPrivacyPolicy(_ sender: UIButton) {
        let contactUsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewHandlerVCID") as! WebViewHandlerViewController
        contactUsVC.modalPresentationStyle = .fullScreen
        self.present(contactUsVC, animated: true)
        
    }
    @IBAction func didClickThirdPartyLicense(_ sender: UIButton) {
        
    }
    @IBAction func didClickTermsOfUse(_ sender: UIButton) {
        
    }
    @IBAction func didClickSupportPage(_ sender: UIButton) {
        let contactUsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactUsVCID") as! ContactUsViewController
        contactUsVC.modalPresentationStyle = .fullScreen
        self.present(contactUsVC, animated: true)
        
    }
    
    @IBAction func didClickLogoutButton(_ sender: UIButton) {
        UserDefaultsHandler.shared.setUserEmail("")
        UserDefaultsHandler.shared.setUserPassword("")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.makeLoginAsRootViewController()
    }
}
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == bankCardsTableView {
            return 3
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
           let cell = bankCardsTableView.dequeueReusableCell(withIdentifier: "ProfileCardListTableViewCell") as! ProfileCardListTableViewCell
        if tableView == bankCardsTableView {
            
        } else {
            if indexPath.row == 2 {
                cell.profileImageView.image = UIImage(named: "VerifiedEmail")
                cell.cardNameNumber.text = "johnDae@gmail.com"
            } else if indexPath.row == 1 {
                cell.profileImageView.image = UIImage(named: "VerifiedEmail")
                cell.cardNameNumber.text = "vijay@gmail.com"
            } else {
                cell.profileImageView.image = UIImage(named: "UnverifiedEmail")
                cell.cardNameNumber.text = "sabin@gmail.com"
            }
            
        }
        cell.selectionStyle = .none
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}
 
extension ProfileViewController: UITableViewDelegate {
    
}
