//
//  AddTransactionViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 28/12/24.
//

import UIKit
import Alamofire
class AddTransactionViewController: UIViewController {
//var addtransactionCount: Int = 1
//    let dropDown = DropDown()
    var createTranscationArray: [CreateTranscationModel] = [CreateTranscationModel]()
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomSeperator: UIView!
    @IBOutlet weak var closeTransactionButton: UIView!
    @IBOutlet weak var transactionTitle: UILabel!
    @IBOutlet weak var addTransactionTableView: UITableView!
    var isFromDashboard: Bool = false
    var expensecategoryArray: [String] = []
    var currentCategoryTagSelected: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        expensecategoryArray = ["+ Add Expenses", "Shopping", "Clothing", "Transportation", "Food", "Other"]
        if isFromDashboard {
            topViewHeightConstraint.constant = 40
            bottomSeperator.isHidden = true
            closeTransactionButton.isHidden = true
        }
        let createTransactionModel = CreateTranscationModel(amount: "", category: "", note: "")
        createTranscationArray.append(createTransactionModel)
        
       
    }
    func registerNib() {
        self.addTransactionTableView.register(UINib(nibName: "AddTransactionTableViewCell",
                                               bundle: nil), forCellReuseIdentifier: "AddTransactionTableViewCell")
        self.addTransactionTableView.delegate = self
        self.addTransactionTableView.dataSource = self
        self.addTransactionTableView.rowHeight = 376
        self.addTransactionTableView.estimatedRowHeight = 376
        self.addTransactionTableView.separatorStyle = .none
        self.addTransactionTableView.reloadData()
    }

    @IBAction func didClickCloseAddTransaction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didClickAddAnotherTransaction(_ sender: UIButton) {
//        addtransactionCount = addtransactionCount + 1
        let createTransactionModel = CreateTranscationModel(amount: "", category: "", note: "")
        createTranscationArray.append(createTransactionModel)
        addTransactionTableView.reloadData()
//        let indexPath = IndexPath(row: 0, section: createTranscationArray.count-1)
//        addTransactionTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        scrollToBottom(animated: false)
    }
    func scrollToBottom(animated: Bool = true) {
        guard addTransactionTableView.numberOfSections > 0 else { return }
        
        let lastSection = addTransactionTableView.numberOfSections - 1
        let lastRow = addTransactionTableView.numberOfRows(inSection: lastSection) - 1
        
        if lastRow >= 0 {
            let indexPath = IndexPath(row: lastRow, section: lastSection)
            addTransactionTableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    @IBAction func didClickSaveTransaction(_ sender: UIButton) {
        let finalDataArray: NSMutableArray = NSMutableArray()
            for i in createTranscationArray {
                var transactionsArray:[String:Any] = [String:Any]()
                transactionsArray = ["amount":i.amount ?? "", "note": i.note ?? "", "category": i.category ?? ""]
                finalDataArray.add(transactionsArray)
            }
            let transactionData:[String: Any] = ["transactionDetails": finalDataArray]
        Utils.shared.startLoaderAnimation(vc: self)
            let auth = AuthCredentials(username: UserDefaultsHandler.shared.getUserEmail() ?? "nalini@gmail.com", password: UserDefaultsHandler.shared.getUserPassword() ?? "Test@123")
            ServiceManager.sharedInstance.executePostUrlWithDecodable(type: GetTransactionsStatus.self, with: UrlConstant.shared.addManualTransaction,params: transactionData, auth: auth, showLoader: true){ (result: AFDataResponse<GetTransactionsStatus>?, statusCode) in
                if statusCode == .success {
                    Utils.shared.stopLoadingAnimation()
                    if result?.value?.status == "success" {
                        if result?.value?.transactionStatus == "success" {
                            Utils.shared.swiftMessageAlert(theme: .success, message: "Manual Transaction created Successfully.", view: self.view, titleMessage: "Success!!!")
                            _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.dismissCurrentView), userInfo: nil, repeats: false)
                        } else {
                            Utils.shared.swiftMessageAlert(theme: .error, message: "Error in creating manual transaction.", view: self.view, titleMessage: "Failed!!!")
                        }
                    } else {
                        Utils.shared.swiftMessageAlert(theme: .error, message: "Error in creating manual transaction.", view: self.view, titleMessage: "Failed!!!")
                    }
                } else {
                    Utils.shared.stopLoadingAnimation()
                    Utils.shared.swiftMessageAlert(theme: .error, message: "Error in creating manual transaction.", view: self.view, titleMessage: "Failed!!!")
                }
            }
    }
    @objc func dismissCurrentView() {
        self.dismiss(animated: true)
    }
    @objc func expenseCategoryButtonTapped(sender: UIButton) {
        currentCategoryTagSelected = sender.tag
        createActionSheet(tag: sender.tag)
    }
    func createActionSheet(tag: Int) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for category in expensecategoryArray {
            
            let action = UIAlertAction(title: category, style: .default, handler: { _ in
                if category == "+ Add Expenses" {
                    self.openCreateCategoryScreen()
                } else {
                    self.createTranscationArray[tag].category = category
                    self.addTransactionTableView.reloadData()
                }
                print("Selected: \(category)")
            })
            if category == "+ Add Expenses" {
                action.setValue(UIColor.systemIndigo, forKey: "titleTextColor")
            }
            alert.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        present(alert, animated: true, completion: nil)
    }
    func openCreateCategoryScreen() {
//        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateCategoryViewController") as? CreateCategoryViewController {
//            vc.modalPresentationStyle = .fullScreen
//            vc.modalTransitionStyle = .crossDissolve
//            vc.isFromDashboard = false
//            self.present(vc, animated: true)
//        }
    }
    @objc func deleteTransactionButtonTapped(sender: UIButton) {
        let tag = sender.tag
        print(addTransactionTableView.numberOfSections)
        addTransactionTableView.beginUpdates()
        createTranscationArray.remove(at: tag)
        addTransactionTableView.deleteSections(IndexSet.init(integer: tag), with: .fade)
        addTransactionTableView.endUpdates()
        addTransactionTableView.reloadData()
    }
    @objc func textFieldChanged(_ textField: UITextField) -> Void {
        let tag = textField.tag
        createTranscationArray[tag].amount = textField.text ?? ""
    }
}
extension AddTransactionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = createTranscationArray[indexPath.section]
        let cell = addTransactionTableView.dequeueReusableCell(withIdentifier: "AddTransactionTableViewCell") as? AddTransactionTableViewCell
        cell?.notesTextView.layer.borderColor = UIColor.lightGray.cgColor
        cell?.notesTextView.layer.borderWidth = 0.5
        cell?.notesTextView.layer.cornerRadius = 8
//        self.dropDown.anchorView = cell?.expenseCategoryButton
        cell?.selectionStyle = .none
        cell?.expenseCategoryButton.tag = indexPath.section
        cell?.expenseCategoryButton.addTarget(self, action: #selector(expenseCategoryButtonTapped), for: .touchUpInside)
        cell?.deleteTransactionButton.tag = indexPath.section
        cell?.deleteTransactionButton.addTarget(self, action: #selector(deleteTransactionButtonTapped), for: .touchUpInside)
        cell?.amountTextField.tag = indexPath.section
        cell?.amountTextField.text = data.amount
        cell?.notesTextView.text = data.note
        cell?.expenseCategoryTextField.text = data.category
        cell?.amountTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        cell?.notesTextView.tag = indexPath.section
        cell?.notesTextView.delegate = self
        if indexPath.section == 0 {
            cell?.deleteTransactionView.isHidden = true
        } else {
            cell?.deleteTransactionView.isHidden = false
        }
        return cell!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return createTranscationArray.count
    }
    
}

extension AddTransactionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 20))
        return footerView
    }
}
struct CreateTranscationModel {
    var amount: String?
    var category: String?
    var note: String?
}
extension AddTransactionViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let tag = textView.tag
        createTranscationArray[tag].note = textView.text
    }
}

