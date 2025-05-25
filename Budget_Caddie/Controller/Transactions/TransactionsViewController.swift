//
//  TransactionsViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 28/12/24.
//

import UIKit
import Alamofire
import SDWebImage

class TransactionsViewController: UIViewController {

    @IBOutlet weak var noTransactionsView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var transactionsTableView: UITableView!
    var transactionsListArray: [TransactionsListDetails] = [TransactionsListDetails]()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.transactionsListArray.removeAll()
        getTransactionsList()
    }
    func showeNoTransactionsView() {
        self.noTransactionsView.isHidden = false
        self.searchView.isHidden = true
        self.transactionsTableView.isHidden = true
    }
    func hideNoTransactionsView() {
        self.noTransactionsView.isHidden = true
        self.searchView.isHidden = false
        self.transactionsTableView.isHidden = false
    }
    func registerNib() {
        self.transactionsTableView.register(UINib(nibName: "TransactionsTableViewCell",
                                               bundle: nil), forCellReuseIdentifier: "TransactionsTableViewCell")
        self.transactionsTableView.delegate = self
        self.transactionsTableView.dataSource = self
        self.transactionsTableView.rowHeight = UITableView.automaticDimension
        self.transactionsTableView.estimatedRowHeight = UITableView.automaticDimension
        self.transactionsTableView.reloadData()
    }
    func getTransactionsList() {
        Utils.shared.startLoaderAnimation(vc: self)
        let auth = AuthCredentials(username: UserDefaultsHandler.shared.getUserEmail() ?? "nalini@gmail.com", password: UserDefaultsHandler.shared.getUserPassword() ?? "Test@123")
        let param: [String: Any] = ["page": 1]
        ServiceManager.sharedInstance.executeGetUrlWithDecodable(type: GetTransactionsList.self, with: UrlConstant.shared.getTransactionsList,params: param,auth: auth, showLoader: true) { (result: AFDataResponse<GetTransactionsList>?, statusCode) in
            if statusCode == .success {
                Utils.shared.stopLoadingAnimation()
                if result?.value?.status == "success" {
                    if result?.value?.transactionData?.count ?? 0 > 0 {
                        if result?.value?.transactionData != nil {
                            
                            self.transactionsListArray = (result?.value?.transactionData)!
                        }
                        self.hideNoTransactionsView()
                        self.transactionsTableView.reloadData()
                    } else {
                        self.showeNoTransactionsView()
                    }
                } else {
                }
            } else {
                Utils.shared.stopLoadingAnimation()
            }
        }
    }
    @IBAction func didClickAddTransactions(_ sender: UIButton) {
        print("Add Transactions button clicked")
        let addTransation = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTransactionVCID") as! AddTransactionViewController
        addTransation.modalTransitionStyle = .crossDissolve
        addTransation.modalPresentationStyle = .fullScreen
        self.present(addTransation, animated: true)
    }
    
    @IBAction func didClickFilter(_ sender: UIButton) {
        print("Filter button clicked")
    }
    
    @IBAction func didClickETransferFund(_ sender: UIButton) {
        print("E-Transfer button clicked")
        let eTransferVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ETransferVCID") as! ETransferViewController
        eTransferVC.modalTransitionStyle = .crossDissolve
        eTransferVC.modalPresentationStyle = .fullScreen
        self.present(eTransferVC, animated: true)
    }
}
extension TransactionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if transactionsListArray[indexPath.row].manualTransaction == true {
            let updateTransactionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdateTransactionVCID") as! UpdateTransactionViewController
            updateTransactionVC.modalTransitionStyle = .crossDissolve
            updateTransactionVC.modalPresentationStyle = .fullScreen
            updateTransactionVC.transactionDetails = transactionsListArray[indexPath.row]
            self.present(updateTransactionVC, animated: true)
        } else {
            self.view.makeToast("Only manual transactions can be edited", duration: 3.0, position: .bottom)
        }
        
    }
}
extension TransactionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionsTableView.dequeueReusableCell(withIdentifier: "TransactionsTableViewCell") as? TransactionsTableViewCell
        if transactionsListArray.count != 0 {
            if let data: TransactionsListDetails = transactionsListArray[indexPath.row] as? TransactionsListDetails {
                cell?.categoryImage.layer.cornerRadius = (cell?.categoryImage.frame.height ?? 40) / 2
                cell?.categoryImage.layer.borderWidth = 1
                cell?.categoryImage.layer.borderColor = UIColor.clear.cgColor
                cell?.selectionStyle = .none
                cell?.transactionAmount.text = "$ " + Utils.shared.checkNullvalue(passedValue: data.amount)
                cell?.transactionDate.text = Utils.shared.checkNullvalue(passedValue: data.transactionDate)
                cell?.categoryName.text =  data.category ?? "Shopping"
                if data.manualTransaction == true {
                    cell?.transactionDescription.text =  data.description ?? "Manual Transaction"
                } else {
                    cell?.transactionDescription.text = Utils.shared.checkNullvalue(passedValue: data.merchantName)
                }
                cell?.categoryImage.sd_setImage(with: URL(string: data.merchantLogoURL ?? ""), placeholderImage: UIImage.init(named: "moneyTransaction"))
            }
        }
        return cell!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
