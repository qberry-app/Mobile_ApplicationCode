//
//  CreateNewGoalViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 29/12/24.
//

import UIKit
import Alamofire
import DropDown
 
class CreateNewGoalViewController: UIViewController {

    @IBOutlet weak var sharedGoalButton: CustomButton!
    @IBOutlet weak var createGoalButton: UIButton!
    @IBOutlet weak var SaveDeleteButtonView: UIView!
    @IBOutlet weak var desiredCompleteionDateBtn: UIButton!
    @IBOutlet weak var desiredCompletionDateTxtFld: UITextField!
    @IBOutlet weak var desiredAmountCurrencyBtn: UIButton!
    @IBOutlet weak var desiredAmountTxtFld: UITextField!
    @IBOutlet weak var startingAmountCurrencyBtn: UIButton!
    @IBOutlet weak var startingAmountTxtFld: UITextField!
    @IBOutlet weak var goalName: UITextField!
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var mainContentView: UIView!
    let dropDown = DropDown()
    var currentGoalTypeNew: Bool = true
    var goalDetails:Goal?
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDown.dataSource = ["CAD", "USD", "GBP"]
        // Do any additional setup after loading the view.
        if currentGoalTypeNew == false {
            goalTitle.text = "Edit Goal"
            SaveDeleteButtonView.isHidden = false
            createGoalButton.isHidden = true
            sharedGoalButton.isHidden = true
            editGoalDetails()
        }
    }
    func editGoalDetails() {
        goalName.text = Utils.shared.checkNullvalue(passedValue: goalDetails?.goalName)
        startingAmountTxtFld.text = Utils.shared.checkNullvalue(passedValue: goalDetails?.currentAmount)
        desiredAmountTxtFld.text = Utils.shared.checkNullvalue(passedValue: goalDetails?.desiredAmount)
        desiredCompletionDateTxtFld.text = Utils.shared.checkNullvalue(passedValue: goalDetails?.completedDate)
        
    }
    @IBAction func didClickClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didClickSaveGoalButton(_ sender: UIButton) {
        print("Save Goal tapped")
        editGoalApi()
    }
    
    @IBAction func didClickDeleteGoal(_ sender: UIButton) {
        print("Delete Goal tapped")
        deleteGoalApi()
    }
    
    @IBAction func didClickCreateGoal(_ sender: UIButton) {
        print("Create Goal tapped")
        createNewGoal()
    }
    func deleteGoalApi() {
        
    }
    func editGoalApi() {
        Utils.shared.startLoaderAnimation(vc: self)
        let auth = AuthCredentials(username: UserDefaultsHandler.shared.getUserEmail() ?? "nalini@gmail.com", password: UserDefaultsHandler.shared.getUserPassword() ?? "Test@123")
        let parameters: [String: Any] = ["goalName": Utils.shared.checkNullvalue(passedValue: goalName.text),
                                         "currentAmount": Utils.shared.checkNullvalue(passedValue: startingAmountTxtFld.text),
                                         "desiredAmount": Utils.shared.checkNullvalue(passedValue: desiredAmountTxtFld.text),
                                         "completedDate": Utils.shared.checkNullvalue(passedValue: desiredCompletionDateTxtFld.text),
                                         "goalId": Utils.shared.checkNullvalue(passedValue: goalDetails?.goalId)]
        ServiceManager.sharedInstance.executePostUrlWithDecodable(type: LoginApiModel.self, with: UrlConstant.shared.editGoal,params: parameters ,auth: auth, showLoader: true) { (result: AFDataResponse<LoginApiModel>?, statusCode) in
            if statusCode == .success {
                Utils.shared.stopLoadingAnimation()
                if result?.value?.status == "success" {
                    Utils.shared.swiftMessageAlert(theme: .success, message: "New Updated successfully", view: self.view, titleMessage: "Success!!!")
                    _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.dismissScreenFunc), userInfo: nil, repeats: false)
                } else {
                    Utils.shared.swiftMessageAlert(theme: .error, message: "Enter valid data to proceed", view: self.view, titleMessage: "Error!!!")
                }
            } else {
                Utils.shared.stopLoadingAnimation()
                Utils.shared.swiftMessageAlert(theme: .error, message: "Enter valid data to proceed", view: self.view, titleMessage: "Error!!!")
            }
        }
    }
    
    @IBAction func didClickDesiredcompletionDateButton(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Date",cancelText: "Cancel",datePickerMode: .date, style: .Inline) { date in
            print("datedatedate", date)
            self.desiredCompletionDateTxtFld.text = Utils.shared.convertDateString(date.formatDateToString())
        }
    }
    @IBAction func didClickDesiredAmountCurrency(_ sender: UIButton) {
        dropDown.direction = .any
        dropDown.anchorView = self.desiredAmountCurrencyBtn
        dropDown.show()
        dropDown.selectionAction = { (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.desiredAmountCurrencyBtn.setTitle(item, for: .normal)
        }
    }
    
    @IBAction func didClickStartingAmountCurrency(_ sender: UIButton) {
        dropDown.direction = .any
        dropDown.anchorView = self.startingAmountCurrencyBtn
        dropDown.show()
        dropDown.selectionAction = { (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.startingAmountCurrencyBtn.setTitle(item, for: .normal)
        }
    }
    func createNewGoal() {
        self.view.endEditing(true)
        if Utils.shared.checkNullvalue(passedValue: goalName.text).isEmpty {
            Utils.shared.makeToast(message: "Please enter goal Name", vc: self)
        } else if Utils.shared.checkNullvalue(passedValue: startingAmountTxtFld.text).isEmpty {
            Utils.shared.makeToast(message: "Please enter the amount", vc: self)
        } else if Utils.shared.checkNullvalue(passedValue: desiredAmountTxtFld.text).isEmpty {
            Utils.shared.makeToast(message: "Please enter the desired amount", vc: self)
        } else if Utils.shared.checkNullvalue(passedValue: desiredCompletionDateTxtFld.text).isEmpty {
            Utils.shared.makeToast(message: "Please enter the desired completion date", vc: self)
        } else {
            makeCreateGoalApi()
        }
    }
    
    @IBAction func didClickCreateSharedGoal(_ sender: UIButton) {
        self.view.endEditing(true)
        if Utils.shared.checkNullvalue(passedValue: goalName.text).isEmpty {
            Utils.shared.makeToast(message: "Please enter goal Name", vc: self)
        } else if Utils.shared.checkNullvalue(passedValue: startingAmountTxtFld.text).isEmpty {
            Utils.shared.makeToast(message: "Please enter the amount", vc: self)
        } else if Utils.shared.checkNullvalue(passedValue: desiredAmountTxtFld.text).isEmpty {
            Utils.shared.makeToast(message: "Please enter the desired amount", vc: self)
        } else if Utils.shared.checkNullvalue(passedValue: desiredCompletionDateTxtFld.text).isEmpty {
            Utils.shared.makeToast(message: "Please enter the desired completion date", vc: self)
        } else {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SplitGoalVCID") as? SplitGoalViewController {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
    }
    func makeCreateGoalApi() {
        Utils.shared.startLoaderAnimation(vc: self)
        let auth = AuthCredentials(username: UserDefaultsHandler.shared.getUserEmail() ?? "nalini@gmail.com", password: UserDefaultsHandler.shared.getUserPassword() ?? "Test@123")
        let parameters: [String: Any] = ["goalName": Utils.shared.checkNullvalue(passedValue: goalName.text),
                                         "currentAmount": Utils.shared.checkNullvalue(passedValue: startingAmountTxtFld.text),
                                         "desiredAmount": Utils.shared.checkNullvalue(passedValue: desiredAmountTxtFld.text),
                                         "completedDate": Utils.shared.checkNullvalue(passedValue: desiredCompletionDateTxtFld.text)]
        ServiceManager.sharedInstance.executePostUrlWithDecodable(type: LoginApiModel.self, with: UrlConstant.shared.createGoal,params: parameters ,auth: auth, showLoader: true) { (result: AFDataResponse<LoginApiModel>?, statusCode) in
            if statusCode == .success {
                Utils.shared.stopLoadingAnimation()
                if result?.value?.status == "success" {
                    Utils.shared.swiftMessageAlert(theme: .success, message: "New Goal created successfully", view: self.view, titleMessage: "Success!!!")
                    _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.dismissScreenFunc), userInfo: nil, repeats: false)
                } else {
                    Utils.shared.swiftMessageAlert(theme: .error, message: "Enter valid data to proceed", view: self.view, titleMessage: "Error!!!")
                }
            } else {
                Utils.shared.stopLoadingAnimation()
                Utils.shared.swiftMessageAlert(theme: .error, message: "Enter valid data to proceed", view: self.view, titleMessage: "Error!!!")
            }
        }
    }
    @objc func dismissScreenFunc() {
        self.dismiss(animated: true)
    }
}
