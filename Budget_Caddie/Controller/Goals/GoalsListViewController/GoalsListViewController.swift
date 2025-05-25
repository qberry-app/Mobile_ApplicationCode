//
//  GoalsListViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 29/12/24.
//

import UIKit
import Alamofire

class GoalsListViewController: UIViewController {

    @IBOutlet weak var goalSearchView: CustomView!
    @IBOutlet weak var noGoalAvailableView: UIView!
    @IBOutlet weak var goalChartView: DPPieChartView!
    @IBOutlet weak var goalListTableView: UITableView!
    var previousOffset: CGFloat = 0
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var targetAmountLbl: UILabel!
    @IBOutlet weak var goalName: UILabel!
    @IBOutlet weak var goalGraph: DPPieChartView!
    @IBOutlet weak var goalGraphView: UIView!
    @IBOutlet weak var searchGoalTxtFld: UITextField!
    var resultArray:[Goal] = [Goal]()
    var searchCompleted:Bool = false
    var headerViews: [UIView] = []
    var goalListArray:[Goal] = [Goal]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchGoalTxtFld.delegate = self
        registerGoalPieChart()
        registerTableViewcell()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utils.shared.startLoaderAnimation(vc: self)
        self.goalListArray.removeAll()
        fetchGoalList()
    }
    func fetchGoalList() {
        
        let auth = AuthCredentials(username: UserDefaultsHandler.shared.getUserEmail() ?? "nalini@gmail.com", password: UserDefaultsHandler.shared.getUserPassword() ?? "Test@123")
        ServiceManager.sharedInstance.executeGetUrlWithDecodable(type:GetUserGoalList.self, with:  UrlConstant.shared.fetchGoal,auth: auth, showLoader: true) { (result: AFDataResponse<GetUserGoalList>?, statusCode) in
            if statusCode == .success {
                Utils.shared.stopLoadingAnimation()
                if result != nil {
                    if result?.value?.goal?.count != 0 {
                        // hide noGoal View
                        self.hideNoGoalView()
                        self.goalListArray = result?.value?.goal ?? []
                        self.goalListTableView.reloadData()
                    } else {
                        // Show noGoal View
                        self.showNoGoalView()
                    }
                } else {
                    self.showNoGoalView()
                    // Show no Goal View
                }
            } else {
                Utils.shared.stopLoadingAnimation()
                self.showNoGoalView()
            }
        }
    }
    
    func showNoGoalView() {
        self.noGoalAvailableView.isHidden = false
        goalGraphView.isHidden = true
        goalSearchView.isHidden = true
        goalListTableView.isHidden = true
    }
    func hideNoGoalView() {
        self.noGoalAvailableView.isHidden = true
        goalGraphView.isHidden = false
        goalSearchView.isHidden = false
        goalListTableView.isHidden = false
    }
    func registerGoalPieChart() {
        goalGraph.datasource = self
        goalGraph.delegate = self
        goalGraph.touchEnabled = true
        goalGraph.bottomSpacing = 0
        goalGraph.topSpacing = 0
        goalGraph.rightSpacing = 0
        goalGraph.leftSpacing = 0
        goalGraph.labelsEnabled = false
        goalGraph.touchAlphaPredominance = 0.4
        goalGraph.reloadData()
    }
    func registerTableViewcell() {
        self.goalListTableView.register(UINib(nibName: "GoalsTrackerTableViewCell",
                                               bundle: nil), forCellReuseIdentifier: "GoalsTrackerTableViewCell")
        
        self.goalListTableView.register(UINib(nibName: "GoalEmergencyFundTableViewCell",
                                               bundle: nil), forCellReuseIdentifier: "GoalEmergencyFundTableViewCell")
        
        self.goalListTableView.register(UINib(nibName: "GoalsTotalUnallocatedSavingsTableViewCell",
                                              bundle: nil), forCellReuseIdentifier: "GoalsTotalUnallocatedSavingsTableViewCell")
        self.goalListTableView.register(UINib(nibName: "AddAmountToGoalTableViewCell",
                                              bundle: nil), forCellReuseIdentifier: "AddAmountToGoalTableViewCell")
        
        self.goalListTableView.delegate = self
        self.goalListTableView.dataSource = self
        self.goalListTableView.separatorStyle = .none
        self.goalListTableView.rowHeight = UITableView.automaticDimension
        self.goalListTableView.estimatedRowHeight = UITableView.automaticDimension
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let visibleRect = CGRect(origin: goalListTableView.contentOffset, size: goalListTableView.bounds.size)
            
            // Check each header view
            for (section, headerView) in headerViews.enumerated() {
                // Get the frame of the section in the table view coordinates
                
                let sectionRect = goalListTableView.rect(forSection: section)
                    // Get section header frame
                    let headerRect = CGRect(x: sectionRect.origin.x,
                                           y: sectionRect.origin.y,
                                           width: sectionRect.width,
                                           height: self.tableView(goalListTableView, heightForHeaderInSection: section))
                    
                    // Check if the header is visible
                    let isHeaderVisible = headerRect.intersects(visibleRect)
                    
                    // Check if we've scrolled past this section
                    let isSectionPassed = scrollView.contentOffset.y > (headerRect.origin.y + headerRect.height)
                    
                    // Show header if it's visible and not passed, otherwise hide it
                    UIView.animate(withDuration: 0.3) {
                        headerView.alpha = (isHeaderVisible && !isSectionPassed) ? 1.0 : 0.0
                    }
                
            }
    }
    
    @IBAction func didClickAddGoalButton(_ sender: UIButton) {
<<<<<<< HEAD
        let createNewGoalVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateNewGoalVCID") as! CreateNewGoalViewController
        createNewGoalVC.modalPresentationStyle = .fullScreen
        self.present(createNewGoalVC, animated: true)
=======
//        let createNewGoalVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateNewGoalVCID") as! CreateNewGoalViewController
//        createNewGoalVC.modalPresentationStyle = .fullScreen
//        self.present(createNewGoalVC, animated: true)
>>>>>>> e0e6825da9059e02b32efbcb9c2d8b9aa4a61de7
    }
    func performGoalSearchAction() {
        Utils.shared.startLoaderAnimation(vc: self)
        let parameter:[String: Any] = ["goalName": Utils.shared.checkNullvalue(passedValue: searchGoalTxtFld.text)]
        let auth = AuthCredentials(username: UserDefaultsHandler.shared.getUserEmail() ?? "nalini@gmail.com", password: UserDefaultsHandler.shared.getUserPassword() ?? "Test@123")
        ServiceManager.sharedInstance.executeGetUrlWithDecodable(type: GetUserGoalList.self, with: UrlConstant.shared.searchGoal,params: parameter, auth: auth, showLoader: true) { (result: AFDataResponse<GetUserGoalList>?, statusCode) in
            if statusCode == .success {
                Utils.shared.stopLoadingAnimation()
                if result?.value != nil {
                    if result?.value?.goal?.count != 0 {
                        if result?.value?.goal != nil {
                            self.resultArray = result?.value?.goal ?? []
                            self.searchCompleted = true
                            self.goalListTableView.reloadData()
                        } else {
                            Utils.shared.swiftMessageAlert(theme: .error, message: "No data found", view: self.view, titleMessage: "Error!!!")
                        }
                    }
                } else {
                    Utils.shared.swiftMessageAlert(theme: .error, message: "Enter valid data to proceed", view: self.view, titleMessage: "Error!!!")
                }
            } else {
                Utils.shared.stopLoadingAnimation()
                Utils.shared.swiftMessageAlert(theme: .error, message: "Enter valid data to proceed", view: self.view, titleMessage: "Error!!!")
            }
        }
    }
    
}
extension GoalsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if searchCompleted {
                return resultArray.count
            } else {
                return goalListArray.count
            }
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        } else {
            if searchCompleted {
                return resultArray.count
            } else {
                return goalListArray.count
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: GoalsTrackerTableViewCell = goalListTableView.dequeueReusableCell(withIdentifier: "GoalsTrackerTableViewCell") as! GoalsTrackerTableViewCell
            cell.selectionStyle = .none
            if searchCompleted {
                let data:Goal = resultArray[indexPath.row]
                cell.goalTitle.text = Utils.shared.checkNullvalue(passedValue: data.goalName)
                cell.currentGoalValue.text = Utils.shared.checkNullvalue(passedValue: data.currentAmount)
            } else {
                let data:Goal = goalListArray[indexPath.row]
                cell.goalTitle.text = Utils.shared.checkNullvalue(passedValue: data.goalName)
                cell.currentGoalValue.text = Utils.shared.checkNullvalue(passedValue: data.currentAmount)
            }
            return cell

        } else if indexPath.section == 1{
            let cell = goalListTableView.dequeueReusableCell(withIdentifier: "GoalEmergencyFundTableViewCell") as! GoalEmergencyFundTableViewCell
            cell.selectionStyle = .none
            return cell
           
        } else if indexPath.section == 2 {
            let cell = goalListTableView.dequeueReusableCell(withIdentifier: "GoalsTotalUnallocatedSavingsTableViewCell") as! GoalsTotalUnallocatedSavingsTableViewCell
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 3 {
            let cell = goalListTableView.dequeueReusableCell(withIdentifier: "AddAmountToGoalTableViewCell") as! AddAmountToGoalTableViewCell
            cell.selectionStyle = .none
            var data:Goal?
//            cell.unallocatedSavingTitle.text =
            if searchCompleted {
                data = resultArray[indexPath.row]
            } else {
                data = goalListArray[indexPath.row]
            }
            cell.unallocatedSavingTitle.text = Utils.shared.checkNullvalue(passedValue: data?.goalName)
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
}
extension GoalsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
<<<<<<< HEAD
        if indexPath.section == 0 {
            let createNewGoalVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateNewGoalVCID") as! CreateNewGoalViewController
            createNewGoalVC.modalPresentationStyle = .fullScreen
            createNewGoalVC.currentGoalTypeNew = false
            if searchCompleted {
                createNewGoalVC.goalDetails = resultArray[indexPath.row]
            } else {
                createNewGoalVC.goalDetails = goalListArray[indexPath.row]
            }
            
            self.present(createNewGoalVC, animated: true)
        }
       
=======
//        if indexPath.section == 0 {
//            let createNewGoalVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateNewGoalVCID") as! CreateNewGoalViewController
//            createNewGoalVC.modalPresentationStyle = .fullScreen
//            createNewGoalVC.currentGoalTypeNew = false
//            if searchCompleted {
//                createNewGoalVC.goalDetails = resultArray[indexPath.row]
//            } else {
//                createNewGoalVC.goalDetails = goalListArray[indexPath.row]
//            }
//            
//            self.present(createNewGoalVC, animated: true)
//        }
>>>>>>> e0e6825da9059e02b32efbcb9c2d8b9aa4a61de7
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width, height: 20.0)
        switch section {
               case 0: label.text = "Goals Tracker"
               case 1: label.text = "Emergency Fund"
               case 2: label.text = "Total Unallocated Savings"
               case 3: label.text = "Organize Unallocated Savings"
               default: label.text = ""
               }
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        headerView.addSubview(label)
        while headerViews.count <= section {
                headerViews.append(UIView())
            }
        headerViews[section] = headerView
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
extension GoalsListViewController: DPPieChartViewDataSource {
    func pieChartView(_ pieChartView: DPPieChartView, colorForSliceAtIndex index: Int) -> UIColor {
        return UIColor.random()
    }
    
    func pieChartView(_ pieChartView: DPPieChartView, valueForSliceAtIndex index: Int) -> CGFloat {
        if index == 0 {
            return 20
        } else if index == 1 {
            return 10
        } else if index == 2 {
            return 10
        } else if index == 3 {
            return 4.0
        } else {
            return 20.0
        }
        
    }
    
    func numberOfSlices(_ pieChartView: DPPieChartView) -> Int {
        return 5
    }
    func pieChartView(_ pieChartView: DPPieChartView, labelForSliceAtIndex index: Int, forValue value: CGFloat, withTotal total: CGFloat) -> String? {
        
        return ""
        
    }
}
extension GoalsListViewController: DPPieChartViewDelegate {
    func pieChartView(_ pieChartView: DPPieChartView, didTouchAtSliceIndex index: Int) {
        if index == 0 {
            progressLbl.text = "40%"
            goalName.text = "Trip to Amsterdam"
        } else if index == 1 {
            progressLbl.text = "20%"
            goalName.text = "New Car"
        } else if index == 2 {
            progressLbl.text = "30%"
            goalName.text = "Trip to Bali"
        } else if index == 3 {
            progressLbl.text = "10%"
            goalName.text = "New House"
        } else {
            progressLbl.text = "60%"
            goalName.text = "New Wedding Ring"
        }
    }
    func pieChartView(_ pieChartView: DPPieChartView, didReleaseTouchFromSliceIndex index: Int) {
        print(index)
    }
}
extension GoalsListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //if desired
        performGoalSearchAction()
        return true
    }
}
