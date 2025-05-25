//
//  SplitGoalViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 12/04/25.
//
protocol NewUserSelectedDelegate {
    func newUserSelected(newUser: String)
}
import UIKit

class SplitGoalViewController: UIViewController {

    @IBOutlet weak var splitTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var splitMembersTableViewCell: UITableView!
    @IBOutlet weak var creatorContributionAmount: UILabel!
    @IBOutlet weak var currentUserTitleLbl: UILabel!
    @IBOutlet weak var currentUserLbl: UILabel!
    @IBOutlet weak var goalDateLbl: UILabel!
    @IBOutlet weak var goalAmountLbl: UILabel!
    @IBOutlet weak var goalNameLbl: UILabel!
    var numberOfMembers: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitTableViewHeight.constant = 0.0
        registerTableView()
    }
    func registerTableView() {
        self.splitMembersTableViewCell.register(UINib(nibName: "SplitGoalTableViewCell",
                                               bundle: nil), forCellReuseIdentifier: "SplitGoalTableViewCell")
        self.splitMembersTableViewCell.delegate = self
        self.splitMembersTableViewCell.dataSource = self
        self.splitMembersTableViewCell.separatorStyle = .none
        self.splitMembersTableViewCell.separatorColor = .clear
        
        self.splitMembersTableViewCell.reloadData()
    }
    @IBAction func didClickAddNewUserButton(_ sender: UIButton) {
        
        let friendsListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FriendsListVCID") as! FriendsListViewController
        friendsListVC.isFromGoal = true
        friendsListVC.newUserSelectedDelegate = self
        friendsListVC.modalPresentationStyle = .fullScreen
        self.present(friendsListVC, animated: true)
       
    }
    func addNewUserToSplitGoal() {
        numberOfMembers += 1
        splitTableViewHeight.constant = CGFloat(numberOfMembers * 91)
        self.splitMembersTableViewCell.reloadData()
    }
    func removeTableViewCell() {
        numberOfMembers -= 1
        splitTableViewHeight.constant = CGFloat(numberOfMembers * 91)
        self.splitMembersTableViewCell.reloadData()
    }
    @IBAction func didClickSaveButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func didClickBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
extension SplitGoalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let alert = UIAlertController(title: nil, message: "Are you sure want to delete the user?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:{ (action: UIAlertAction!) in
                self.removeTableViewCell()
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
           
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
}
extension SplitGoalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfMembers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = splitMembersTableViewCell.dequeueReusableCell(withIdentifier: "SplitGoalTableViewCell") as? SplitGoalTableViewCell {
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
extension SplitGoalViewController: NewUserSelectedDelegate {
    func newUserSelected(newUser: String) {
        self.addNewUserToSplitGoal()
    }
    
}
