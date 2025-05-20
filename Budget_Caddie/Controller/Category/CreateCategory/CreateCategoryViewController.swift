//
//  CreateCategoryViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 10/02/25.
//

import UIKit
import DropDown


class CreateCategoryViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIView!
    var theme: SambagTheme = .light
    @IBOutlet weak var enterDateLbl: UITextField!
    
    @IBOutlet weak var enterCategoryNameLbl: UITextField!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var budgetMaxTextField: UITextField!
    
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var partialBudgetTextField: UITextField!
    @IBOutlet weak var remainingDaysLbl: UILabel!
    @IBOutlet weak var categoryDateLbl: UILabel!
    var isFromDashboard:Bool = true
    var dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDown.anchorView = categoryDateLbl
        dropDown.dataSource = ["Weekly", "Monthly", "Yearly"]
        if isFromDashboard {
            backButton.isHidden = true
            headerView.isHidden = true
            headerViewHeightConstraint.constant = 0
        } else {
            backButton.isHidden = false
            headerView.isHidden = false
            headerViewHeightConstraint.constant = 52
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func didClickSaveButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didClickDatePick(_ sender: UIButton) {
        showCustomDatePicker()
    }
    @IBAction func didClickPickBudgetDate(_ sender: UIButton) {
        dropDown.direction = .any
        dropDown.show()
        dropDown.selectionAction = { (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.categoryDateLbl.text = item
        }
    }
    @IBAction func didClickMoreCategory(_ sender: UIButton) {
//        let defaultCategoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectDefaultCategoriesVCID") as! SelectDefaultCategoriesViewController
//        defaultCategoryVC.modalPresentationStyle = .fullScreen
//        self.present(defaultCategoryVC, animated: true)
    }
    
    @IBAction func didClickCustomCategoryButton(_ sender: UIButton) {
    }
    func showCustomDatePicker() {
        let vc = SambagDatePickerViewController()
        var limit = SambagSelectionLimit()
        limit.selectedDate = Date()
        let calendar = Calendar.current
        limit.minDate = calendar.date(
            byAdding: .day,
            value: 0,
            to: limit.selectedDate,
            wrappingComponents: false
        )
        limit.maxDate = calendar.date(
            byAdding: .year,
            value: 50,
            to: limit.selectedDate,
            wrappingComponents: false
        )
        vc.hasDayOfWeek = true
        vc.limit = limit
        vc.theme = theme
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
}
extension CreateCategoryViewController: SambagDatePickerViewControllerDelegate {
    func sambagDatePickerDidSet(_ viewController: SambagDatePickerViewController, result: SambagDatePickerResult) {
        var text = result.description
        if viewController.hasDayOfWeek, let dayOfWeek = result.dayOfWeek {
            text = "\(dayOfWeek) " + text
        }
        enterDateLbl.text = text
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagDatePickerDidCancel(_ viewController: SambagDatePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    
}
