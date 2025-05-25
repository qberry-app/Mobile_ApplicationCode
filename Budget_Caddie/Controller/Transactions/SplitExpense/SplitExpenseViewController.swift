//
//  SplitExpenseViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 15/01/25.
//

import UIKit

class SplitExpenseViewController: UIViewController {
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var selectTransactionView: UIView!
    
    @IBOutlet weak var selectTransactSubView: UIView!
    @IBOutlet weak var confirmSplitButton: UIButton!
    @IBOutlet weak var splitExpenseTableView: UITableView!
    @IBOutlet weak var totalAmountView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableCell()
        let arrView = [totalAmountView, selectTransactionView,confirmSplitButton, selectTransactSubView]
        for i in arrView {
            Utils.shared.setupCornerRadius(for: i!, borderWidth: 0.2)
        }
        
        // Do any additional setup after loading the view.
    }
    
    func registerTableCell() {
        self.splitExpenseTableView.register(UINib(nibName: "SplitExpenseTableViewHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "SplitExpenseTableViewHeaderCell")
        
        splitExpenseTableView.register(UINib(nibName: "SplitExpenseTableViewCell",
                                             bundle: nil), forCellReuseIdentifier: "SplitExpenseTableViewCell")
        splitExpenseTableView.delegate = self
        splitExpenseTableView.dataSource = self
        splitExpenseTableView.estimatedRowHeight = 125
        splitExpenseTableView.rowHeight = 125
        splitExpenseTableView.separatorStyle = .none
        splitExpenseTableView.reloadData()
    }
    
    @IBAction func didClickBackButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func confirmSplitButton(_ sender: UIButton) {
        
    }
    
}
extension SplitExpenseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SplitExpenseTableViewCell", for: indexPath) as! SplitExpenseTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
extension SplitExpenseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .darkGray
        label.text = "Allocations"
        headerView.addSubview(label)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SplitExpenseTableViewHeaderCell") as! SplitExpenseTableViewHeaderCell
        return headerCell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}
