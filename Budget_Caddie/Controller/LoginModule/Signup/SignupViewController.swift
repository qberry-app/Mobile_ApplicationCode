//
//  SignupViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 18/12/24.
//

import UIKit
import DatePicker
import Alamofire
import Toast_Swift
import CountryPickerView
class SignupViewController: UIViewController {

    @IBOutlet weak var confirmPasswordTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var dobTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var phoneNumberTxtFld: UITextField!
    @IBOutlet weak var lastNameTxtFld: UITextField!
    @IBOutlet weak var firstNameTxtFld: UITextField!
    
    @IBOutlet weak var countryCodeLbl: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var confirmPasswordButton: UIButton!
    let cpv = CountryPickerView()
    var emailTextinSignup: String = String()
    var passwordTextinSignup: String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        showPasswordButton.setImage(UIImage.init(named: "EyeHide"), for: .normal)
        confirmPasswordButton.setImage(UIImage.init(named: "EyeHide"), for: .normal)
        cpv.frame = view.bounds
        cpv.dataSource = self
        cpv.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func didClickDob(_ sender: UIButton) {
        let minDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 1980)!
//                let maxDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 2025)!
                let today = Date()
                // Create picker object
                let datePicker = DatePicker()
                // Setup
                datePicker.setup(beginWith: today, min: minDate, max: today) { (selected, date) in
                    if selected, let selectedDate = date {
                        print(selectedDate.string())
                        self.dobTxtFld.text = selectedDate.string()
                    } else {
                        print("Cancelled")
                    }
                }
                // Display
                datePicker.show(in: self, on: sender)
    }
    func checkSignupFields() -> (Bool, String) {
        if firstNameTxtFld.text?.count == 0 {
            return (false, "First Name is required")
        } else if lastNameTxtFld.text?.count == 0 {
            return (false, "Last Name is required")
        } else if phoneNumberTxtFld.text?.count == 0 {
            return (false, "Phone Number is required")
        } else if emailTxtFld.text?.count == 0 {
            return (false, "Email is required")
        } else if dobTxtFld.text?.count == 0 {
            return (false, "Date of Birth is required")
        } else if passwordTxtFld.text?.count == 0 {
            return (false, "Password is required")
        } else if confirmPasswordTxtFld.text?.count == 0 {
            return (false, "Confirm Password is required")
        } else if (passwordTxtFld.text != confirmPasswordTxtFld.text) {
            return (false, "Password and Confirm Password does not match")
        } else if !(Utils.shared.isValidPassword(passwordText: passwordTxtFld.text ?? "")) {
            return (false, "Enter a vaid password")
        } else if !(Utils.shared.isValidEmail(emailTxtFld.text ?? "")) {
            return (false , "Enter a valid email")
        } else {
            return (true, "")
        }
    }
    
    @IBAction func didClickChooseCountryCode(_ sender: UIButton) {
        cpv.showCountriesList(from: self)
    }
    @IBAction func didClickSignupButton(_ sender: UIButton) {
        let (isValid, errorMsg) = checkSignupFields()
        if isValid {
            let parameters: [String: Any] = [
                "name": firstNameTxtFld.text ?? "",
                "email": emailTxtFld.text ?? "",
                "password": passwordTxtFld.text ?? "",
                "phoneNumber": phoneNumberTxtFld.text ?? "",
                "countryCode": countryCodeLbl.text ?? "",
                "dateOfBirth": Utils.shared.convertDateFormat(from: dobTxtFld.text ?? "") ?? ""
            ]
            Utils.shared.startLoaderAnimation(vc: self)
            ServiceManager.sharedInstance.executePostUrlWithDecodable(type: LoginApiModel.self, with: UrlConstant.shared.signup, params: parameters, showLoader: true) { (result: AFDataResponse<LoginApiModel>?, statusCode) in
                if statusCode == .success {
                    Utils.shared.stopLoadingAnimation()
                    if result?.value?.status == "success" {
                        let statusMessage = result?.value?.data?[0]
                        if statusMessage == "success" {
                            self.emailTextinSignup = Utils.shared.checkNullvalue(passedValue: self.emailTxtFld.text)
                            self.passwordTextinSignup = Utils.shared.checkNullvalue(passedValue: self.passwordTxtFld.text)
                            _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.moveToLoginScreen), userInfo: nil, repeats: false)
                            Utils.shared.swiftMessageAlert(theme: .success, message: "You have signup to BudgetCaddie successfully", view: self.view, titleMessage: "Success!!!")
                        } else if statusMessage == "user already exist" {
                            Utils.shared.makeToast(message: "user already exist", vc: self)
                        } else {
                            Utils.shared.makeToast(message: statusMessage ?? "", vc: self)
                        }
                    }
                } else if statusCode == .serviceUnavailable {
                    Utils.shared.stopLoadingAnimation()
                    Utils.shared.makeToast(message: "Some error occurred", vc: self)
                }
            }
            
            
        } else {
            Utils.shared.makeToast(message: errorMsg, vc: self)
        }
    }
    @objc func moveToLoginScreen() {
        // Something cool
        moveToLogin()
    }
    @IBAction func didClickShowPasswordButton(_ sender: UIButton) {
        if showPasswordButton.currentImage == UIImage.init(named: "EyeHide") {
            showPasswordButton.setImage(UIImage.init(named: "EyeShow"), for: .normal)
            passwordTxtFld.isSecureTextEntry = false
        } else {
            showPasswordButton.setImage(UIImage.init(named: "EyeHide"), for: .normal)
            passwordTxtFld.isSecureTextEntry = true
        }
    }
    
    @IBAction func didClickLoginAction(_ sender: UIButton) {
        moveToLogin()
    }
    
    func moveToLogin() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVCID") as? LoginViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.isFromSignup = true
            vc.emailTextFromSignup = emailTextinSignup
            vc.passwordTextFromSignup = passwordTextinSignup
            self.present(vc, animated: true)
        }
    }
    @IBAction func didClickShowConfirmPasswordButton(_ sender: UIButton) {
        if confirmPasswordButton.currentImage == UIImage.init(named: "EyeHide") {
            confirmPasswordButton.setImage(UIImage.init(named: "EyeShow"), for: .normal)
            confirmPasswordTxtFld.isSecureTextEntry = false
        } else {
            confirmPasswordButton.setImage(UIImage.init(named: "EyeHide"), for: .normal)
            confirmPasswordTxtFld.isSecureTextEntry = true
        }
    }
}
extension SignupViewController: CountryPickerViewDataSource {
    
}
extension SignupViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print(country)
        self.countryCodeLbl.text = (country.phoneCode)
    }
    
}
