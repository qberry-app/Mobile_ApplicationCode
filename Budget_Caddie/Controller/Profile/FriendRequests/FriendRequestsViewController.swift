//
//  FriendRequestsViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 31/01/25.
//

import UIKit

class FriendRequestsViewController: UIViewController {

    @IBOutlet weak var noRequestAvailableView: UIView!
    @IBOutlet weak var friendsListTableView: UITableView!
    var friendsRequestCount:Int = 3
    var groupRequestCount:Int = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableCell()
        registerGroupCell()
        if friendsRequestCount == 0 {
            noRequestAvailableView.isHidden = false
            friendsListTableView.isHidden = true
        } else {
            noRequestAvailableView.isHidden = true
            friendsListTableView.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    func registerTableCell() {
        self.friendsListTableView.register(UINib(nibName: "FriendsRequestTableViewCell",
                                               bundle: nil), forCellReuseIdentifier: "FriendsRequestTableViewCell")
        self.friendsListTableView.rowHeight = 110.0
        self.friendsListTableView.estimatedRowHeight = 110.0
        self.friendsListTableView.delegate = self
        self.friendsListTableView.separatorStyle = .none
        self.friendsListTableView.dataSource = self
        self.friendsListTableView.reloadData()
    }
    
    func registerGroupCell() {
        
        self.friendsListTableView.register(UINib(nibName: "GroupRequestsTableViewCell",
                                               bundle: nil), forCellReuseIdentifier: "GroupRequestsTableViewCell")
        self.friendsListTableView.rowHeight = 125.0
        self.friendsListTableView.estimatedRowHeight = 125.0
        self.friendsListTableView.delegate = self
        self.friendsListTableView.separatorStyle = .none
        self.friendsListTableView.dataSource = self
        self.friendsListTableView.reloadData()
    }
    
    @IBAction func didClickBackButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @objc func acceptButtonTapped(sender: UIButton) {
        if friendsRequestCount > 0 {
            friendsRequestCount = friendsRequestCount - 1
        }
        
        if friendsRequestCount == 0  && groupRequestCount == 0{
            noRequestAvailableView.isHidden = false
            friendsListTableView.isHidden = true
        }
        self.friendsListTableView.reloadData()
    }
    @objc func acceptGroupRequest(sender: UIButton) {
        if groupRequestCount > 0 {
            groupRequestCount = groupRequestCount - 1
        }
        if friendsRequestCount == 0  && groupRequestCount == 0{
            noRequestAvailableView.isHidden = false
            friendsListTableView.isHidden = true
        }
        self.friendsListTableView.reloadData()
    }
    
}
extension FriendRequestsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView2 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 22))
         let label = UILabel()
          label.frame = CGRect.init(x: 5, y: 5, width: headerView2.frame.width-10, height: headerView2.frame.height)
        if section == 0 {
            label.text = "Friend Requests"
        } else {
            label.text = "Group Requests"
        }
         label.font = .systemFont(ofSize: 18, weight: .bold)
         label.textColor = .black
         headerView2.addSubview(label)
         return headerView2
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let profileSearchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewOtherProfileVCID") as! ViewOtherProfileViewController
            profileSearchVC.modalPresentationStyle = .fullScreen
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            present(profileSearchVC, animated: false)
        } else {
            let viewGroupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewGroupViewController") as! ViewGroupViewController
            viewGroupVC.modalPresentationStyle = .fullScreen
            self.present(viewGroupVC, animated: true)
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 110
        } else {
            return 125.0
        }
    }
}
extension FriendRequestsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return friendsRequestCount
        } else {
            return groupRequestCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if let cell = friendsListTableView.dequeueReusableCell(withIdentifier: "FriendsRequestTableViewCell") as? FriendsRequestTableViewCell {
                cell.selectionStyle = .none
                cell.acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
                cell.rejectButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
                return cell
            }
        } else {
            if let cell = friendsListTableView.dequeueReusableCell(withIdentifier: "GroupRequestsTableViewCell") as? GroupRequestsTableViewCell {
                cell.selectionStyle = .none
                cell.acceptButton.addTarget(self, action: #selector(acceptGroupRequest), for: .touchUpInside)
                cell.declineButton.addTarget(self, action: #selector(acceptGroupRequest), for: .touchUpInside)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
}
