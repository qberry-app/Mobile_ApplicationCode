//
//  ETransferViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 15/01/25.
//

import UIKit

class ETransferViewController: UIViewController {

    @IBOutlet weak var backButton: UIView!
    @IBOutlet weak var confirmSplitButton: CustomButton!
    @IBOutlet weak var transferListTable: UITableView!
    @IBOutlet weak var segmentControl: BetterSegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControl.segments = LabelSegment.segments(withTitles: ["Incoming", "Outgoing", "All"],
                                                        normalTextColor: .black,
                                                        selectedTextColor: UIColor(red: 0.92, green: 0.29, blue: 0.15, alpha: 1.00))
        segmentControl.addTarget(self, action: #selector(segmentedControl1ValueChanged(_:)), for: .valueChanged)
        registerTableViewcell()
        // Do any additional setup after loading the view.
    }
    
    func registerTableViewcell() {
        self.transferListTable.register(UINib(nibName: "ETransferTableViewCell",
                                              bundle: nil), forCellReuseIdentifier: "ETransferTableViewCell")
        self.transferListTable.register(UINib(nibName: "ETransferTableViewHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "ETransferTableViewHeaderCell")
        self.transferListTable.dataSource = self
        self.transferListTable.delegate = self
        self.transferListTable.estimatedRowHeight = 162
        self.transferListTable.rowHeight = 162
        self.transferListTable.separatorStyle = .none
        self.transferListTable.reloadData()
    }
    @IBAction func segmentedControl1ValueChanged(_ sender: BetterSegmentedControl) {
        print("The selected index is \(sender.index)")
    }
    @IBAction func didClickBackButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didClickConfirmSplitButton(_ sender: UIButton) {
    }
}
extension ETransferViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ETransferTableViewCell") as! ETransferTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ETransferTableViewHeaderCell") as! ETransferTableViewHeaderCell
        headerCell.backgroundColor = UIColor.lightGray
        return headerCell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    
}

extension ETransferViewController: UITableViewDelegate {
    
}
