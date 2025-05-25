//
//  FriendsListViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 19/01/25.
//

import UIKit

class FriendsListViewController: UIViewController {

    @IBOutlet weak var myFriendsTableView: UITableView!
    var newUserSelectedDelegate: NewUserSelectedDelegate?
    var isFromGoal: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableCell()
    }
    func registerTableCell() {
        self.myFriendsTableView.register(UINib(nibName: "MyFriendsListTableViewCell",
                                               bundle: nil), forCellReuseIdentifier: "MyFriendsListTableViewCell")
        self.myFriendsTableView.register(UINib(nibName: "MyFriendsListTableViewFooterCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "MyFriendsListTableViewFooterCell")
        self.myFriendsTableView.rowHeight = 111.0
        self.myFriendsTableView.estimatedRowHeight = 111.0
        self.myFriendsTableView.delegate = self
        self.myFriendsTableView.separatorStyle = .none
        self.myFriendsTableView.dataSource = self
        self.myFriendsTableView.reloadData()
    }
    @IBAction func didClickCloseMyFriendsVC(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didClickOpenNotification(_ sender: UIButton) {
        let friendsListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FriendRequestsVCID") as! FriendRequestsViewController
        friendsListVC.modalPresentationStyle = .fullScreen
        friendsListVC.modalTransitionStyle = .crossDissolve
        self.present(friendsListVC, animated: true)
    }
    
    @IBAction func didClickAddFriendsButton(_ sender: UIButton) {
        let profileSearchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchApplicationUsersVCID") as! SearchApplicationUsersViewController
        profileSearchVC.modalPresentationStyle = .fullScreen
        profileSearchVC.modalTransitionStyle = .crossDissolve
        self.present(profileSearchVC, animated: true)
    }
    func shareButtonAction() {
        let firstActivityItem = "Description you want.."

            // Setting url
            let secondActivityItem : NSURL = NSURL(string: "https://www.budgetcaddie.com/")!
            
            // If you want to use an image
            let image : UIImage = UIImage(named: "BudgetCaddieLogo")!
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
            
            // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (myFriendsTableView.tableFooterView as! UIButton)
            
            // This line remove the arrow of the popover to show in iPad
            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
            
            // Pre-configuring activity items
            activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
            ] as? UIActivityItemsConfigurationReading
            
            // Anything you want to exclude
        if #available(iOS 16.0, *) {
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.postToWeibo,
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo,
                UIActivity.ActivityType.postToFacebook,
                UIActivity.ActivityType.mail,
                UIActivity.ActivityType.message,
                UIActivity.ActivityType.airDrop,
                UIActivity.ActivityType.openInIBooks,
                UIActivity.ActivityType.copyToPasteboard,
                UIActivity.ActivityType.postToTwitter,
                UIActivity.ActivityType.collaborationCopyLink
            ]
        } else {
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.postToWeibo,
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo,
                UIActivity.ActivityType.postToFacebook,
                UIActivity.ActivityType.mail,
                UIActivity.ActivityType.message,
                UIActivity.ActivityType.airDrop,
                UIActivity.ActivityType.openInIBooks,
                UIActivity.ActivityType.copyToPasteboard,
                UIActivity.ActivityType.postToTwitter
            ]
        }
            activityViewController.isModalInPresentation = true
            self.present(activityViewController, animated: true, completion: nil)
    }
    @objc func handleShareButtonTapped() {
        shareButtonAction()
    }
}
extension FriendsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
            let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MyFriendsListTableViewFooterCell") as! MyFriendsListTableViewFooterCell
            headerCell.shareButton.addTarget(self, action: #selector(handleShareButtonTapped), for: .touchUpInside)
            return headerCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromGoal {
            newUserSelectedDelegate?.newUserSelected(newUser: "userName")
            self.dismiss(animated: true)
        } else {
            let profileSearchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewOtherProfileVCID") as! ViewOtherProfileViewController
            profileSearchVC.modalPresentationStyle = .fullScreen
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            present(profileSearchVC, animated: false)
        }
    }
    
}
extension FriendsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = myFriendsTableView.dequeueReusableCell(withIdentifier: "MyFriendsListTableViewCell") as? MyFriendsListTableViewCell {
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
