//
//  BudgetListViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 28/12/24.
//

import UIKit

class BudgetListViewController: UIViewController {

    @IBOutlet weak var budgetListTableView: UITableView!

    @IBOutlet weak var budgetGraphView: UIView!
    
    @IBOutlet weak var remainingAmountLbl: UILabel!
    @IBOutlet weak var limitAmountLbl: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var budgetChartView: DPPieChartView!
    var headerViews: [UIView] = []
    var previousOffset: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
//        Utils.shared.setupCornerRadius(for: budgetGraphView, borderWidth: 0.4)
        // Do any additional setup after loading the view.
    }
    func registerCell() {
        registerBudgetChart()
        self.budgetListTableView.register(UINib(nibName: "BudgetSearchTableViewHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "BudgetSearchTableViewHeaderCell")
        // Category Overview
        self.budgetListTableView.register(UINib(nibName: "BudgetListTableViewCell",
                                               bundle: nil), forCellReuseIdentifier: "BudgetListTableViewCell")
        // Budget Adjustments
        self.budgetListTableView.register(UINib(nibName: "BudgetAdjustmentTableViewCell",
                                               bundle: nil), forCellReuseIdentifier: "BudgetAdjustmentTableViewCell")
        self.budgetListTableView.delegate = self
        self.budgetListTableView.dataSource = self
        self.budgetListTableView.separatorStyle = .none
        
        self.budgetListTableView.reloadData()
        
    }
    func registerBudgetChart() {
        budgetChartView.datasource = self
        budgetChartView.delegate = self
        budgetChartView.touchEnabled = true
        budgetChartView.bottomSpacing = 0
        budgetChartView.topSpacing = 0
        budgetChartView.rightSpacing = 0
        budgetChartView.leftSpacing = 0
        budgetChartView.labelsEnabled = false
        budgetChartView.touchAlphaPredominance = 0.4
        budgetChartView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let visibleRect = CGRect(origin: budgetListTableView.contentOffset, size: budgetListTableView.bounds.size)
            
            // Check each header view
            for (section, headerView) in headerViews.enumerated() {
                // Get the frame of the section in the table view coordinates
                
                let sectionRect = budgetListTableView.rect(forSection: section)
                    // Get section header frame
                    let headerRect = CGRect(x: sectionRect.origin.x,
                                           y: sectionRect.origin.y,
                                           width: sectionRect.width,
                                           height: self.tableView(budgetListTableView, heightForHeaderInSection: section))
                    
                    // Check if the header is visible
                    let isHeaderVisible = headerRect.intersects(visibleRect)
                    
                    // Check if we've scrolled past this section
                    let isSectionPassed = scrollView.contentOffset.y > (headerRect.origin.y + headerRect.height)
                    
                    // Show header if it's visible and not passed, otherwise hide it
                    UIView.animate(withDuration: 0.2) {
                        headerView.alpha = (isHeaderVisible && !isSectionPassed) ? 1.0 : 0.0
                    }
                
            }
    }
    
    @IBAction func didClickOpenChatButton(_ sender: UIButton) {
        print("Open chat button clicked")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVCID") as! ChatViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    @IBAction func didClickCreateCategoryButton(_ sender: UIButton) {
        print("Create Category clicked")
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateCategoryViewController") as? CreateCategoryViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.isFromDashboard = false
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func didClickSharedCategoryButton(_ sender: UIButton) {
        print("Shared Budget clicked")
    }
}
extension BudgetListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 120
        } else {
            return 40
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if section == 0 {
                let headerView1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 100))
                let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BudgetSearchTableViewHeaderCell") as! BudgetSearchTableViewHeaderCell
                headerCell.frame = CGRect.init(x: 0, y: 0, width: headerView1.frame.width, height: 66)
                    headerView1.addSubview(headerCell)
                let label = UILabel()
                 label.frame = CGRect.init(x: 5, y: 67, width: headerView1.frame.width-10, height: 20)
                label.text = "Category Overview"
                label.font = .systemFont(ofSize: 16, weight: .bold)
                label.textColor = .black
                headerView1.addSubview(label)
                while headerViews.count <= section {
                        headerViews.append(UIView())
                    }
                headerViews[section] = headerView1
                return headerView1
            } else {
               let headerView2 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
                let label = UILabel()
                 label.frame = CGRect.init(x: 5, y: 5, width: headerView2.frame.width, height: headerView2.frame.height-10)
                label.text = "Budget Adjustments"
                label.font = .systemFont(ofSize: 16, weight: .bold)
                label.textColor = .black
                headerView2.addSubview(label)
                while headerViews.count <= section {
                        headerViews.append(UIView())
                    }
                headerViews[section] = headerView2
                return headerView2
            }
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else {
            return 60
        }
    }
}
extension BudgetListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = budgetListTableView.dequeueReusableCell(withIdentifier: "BudgetListTableViewCell") as? BudgetListTableViewCell
            cell?.selectionStyle = .none
            return cell!
        } else {
             let cell = budgetListTableView.dequeueReusableCell(withIdentifier: "BudgetAdjustmentTableViewCell") as? BudgetAdjustmentTableViewCell
            cell?.selectionStyle = .none
            cell?.setupStepper()
            return cell!
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 5
        }
    }
}
extension BudgetListViewController: DPPieChartViewDataSource {
    
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
extension BudgetListViewController: DPPieChartViewDelegate {
    func pieChartView(_ pieChartView: DPPieChartView, didTouchAtSliceIndex index: Int) {
        if index == 0 {
            limitAmountLbl.text = "$ 500"
            remainingAmountLbl.text = "$ 200"
            categoryLabel.text = "Entertainment"
        } else if index == 1 {
            limitAmountLbl.text = "$ 200"
            remainingAmountLbl.text = "$ 50"
            categoryLabel.text = "Shopping"
        } else if index == 2 {
            limitAmountLbl.text = "$ 300"
            remainingAmountLbl.text = "$ 200"
            categoryLabel.text = "GirlFriend"
        } else if index == 3 {
            limitAmountLbl.text = "$ 1000"
            remainingAmountLbl.text = "$ 350"
            categoryLabel.text = "Rent"
        } else {
            limitAmountLbl.text = "$ 600"
            remainingAmountLbl.text = "$ 180"
            categoryLabel.text = "Transport"
        }
    }
    func pieChartView(_ pieChartView: DPPieChartView, didReleaseTouchFromSliceIndex index: Int) {
        print(index)
    }
}
