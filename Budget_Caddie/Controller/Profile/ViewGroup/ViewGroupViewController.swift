//
//  ViewGroupViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 10/02/25.
//

import UIKit

class ViewGroupViewController: UIViewController {

    @IBOutlet weak var groupMembersTableView: UITableView!
    @IBOutlet weak var groupMembersSearchBar: UITextField!
    @IBOutlet weak var membersCountLbl: UILabel!
    @IBOutlet weak var createdDateLbl: UILabel!
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupImage.layer.cornerRadius = self.groupImage.bounds.size.width / 2.0
          self.groupImage.clipsToBounds = true
        registerTableView()
        // Do any additional setup after loading the view.
    }
    func registerTableView() {
        self.groupMembersTableView.register(UINib(nibName: "GroupMembersTableViewCell",
                                              bundle: nil), forCellReuseIdentifier: "GroupMembersTableViewCell")
        
        self.groupMembersTableView.delegate = self
        self.groupMembersTableView.dataSource = self
        self.groupMembersTableView.separatorStyle = .none
        self.groupMembersTableView.rowHeight = UITableView.automaticDimension
        self.groupMembersTableView.estimatedRowHeight = UITableView.automaticDimension
        self.groupMembersTableView.reloadData()
    }
    @IBAction func didClickBackButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
extension ViewGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileSearchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewOtherProfileVCID") as! ViewOtherProfileViewController
        profileSearchVC.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeIn)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(profileSearchVC, animated: false)
    }
}
extension ViewGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupMembersTableView.dequeueReusableCell(withIdentifier: "GroupMembersTableViewCell") as! GroupMembersTableViewCell
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
