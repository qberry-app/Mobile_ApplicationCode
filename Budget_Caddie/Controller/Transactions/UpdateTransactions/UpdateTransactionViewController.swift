//
//  UpdateTransactionViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 28/12/24.
//

import UIKit
import DropDown

class UpdateTransactionViewController: UIViewController {

    @IBOutlet weak var updateTransactionButton: UIButton!
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var expenseCategoryTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    var transactionDetails: TransactionsListDetails?
    var expensecategoryArray: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        updatecurrentUI()
        // Do any additional setup after loading the view.
    }
    func updatecurrentUI(){
        expensecategoryArray = ["+ Add Expenses", "Shopping", "Clothing", "Transportation", "Food", "Other"]
//        updateTransactionButton.layer.cornerRadius = 10
        updateTransactionButton.layer.masksToBounds = true
        updateTransactionButton.layer.borderColor = UIColor.lightGray.cgColor
        updateTransactionButton.layer.shadowColor = UIColor.gray.cgColor
        updateTransactionButton.layer.shadowOpacity = 0.2
        updateTransactionButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        updateTransactionButton.layer.shadowRadius = 6
        
        notesTextView.layer.borderColor = UIColor.lightGray.cgColor
        notesTextView.layer.borderWidth = 0.5
        notesTextView.layer.cornerRadius = 8
        
        amountTextField.text = Utils.shared.checkNullvalue(passedValue: transactionDetails?.amount ?? "")
        notesTextView.text = Utils.shared.checkNullvalue(passedValue: transactionDetails?.description)
        expenseCategoryTextField.text = Utils.shared.checkNullvalue(passedValue: transactionDetails?.category)
    }
    
    @IBAction func didClickClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didClickExpenseCategory(_ sender: UIButton) {
        createActionSheet()
    }
    
    @IBAction func didClickUpdateTransaction(_ sender: UIButton) {
        // Update the current transaction
        self.dismiss(animated: true)
    }
    func createActionSheet() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for category in expensecategoryArray {
            
            let action = UIAlertAction(title: category, style: .default, handler: { _ in
                if category == "+ Add Expenses" {
                    self.openCreateCategoryScreen()
                } else {
                    self.expenseCategoryTextField.text = category
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
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateCategoryViewController") as? CreateCategoryViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.isFromDashboard = false
            self.present(vc, animated: true)
        }
    }
    @IBAction func didClickSplitExpense(_ sender: UIButton) {
        let splitExpense = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SplitExpenseVCID") as! SplitExpenseViewController
        splitExpense.modalTransitionStyle = .crossDissolve
        splitExpense.modalPresentationStyle = .fullScreen
        self.present(splitExpense, animated: true)
    }
}
