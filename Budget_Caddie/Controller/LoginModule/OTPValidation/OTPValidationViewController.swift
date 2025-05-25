//
//  OTPValidationViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 18/12/24.
//

import UIKit
import Alamofire
class OTPValidationViewController: UIViewController {

    @IBOutlet weak var code2TextField: UITextField!
    @IBOutlet weak var code1TextField: UITextField!
    
    @IBOutlet weak var code3TextField: UITextField!
    
    @IBOutlet weak var code6TextField: UITextField!
    @IBOutlet weak var code5TextField: UITextField!
    @IBOutlet weak var code4TextField: UITextField!
    var userPhoneNumber: String = String()
    var userEmailid: String = String()
    var countryCode: String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        code1TextField.delegate = self
        code2TextField.delegate = self
        code3TextField.delegate = self
        code4TextField.delegate = self
        code5TextField.delegate = self
        code6TextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didClickBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func checkCodeFields() -> (Bool, String) {
        if code1TextField.text?.count == 0 {
            return (false, "Please enter code1")
        } else if code2TextField.text?.count == 0 {
            return (false, "Please enter code2")
        } else if code3TextField.text?.count == 0 {
            return (false, "Please enter code3")
        } else if code4TextField.text?.count == 0 {
            return (false, "Please enter code4")
        } else {
            return (true, "")
        }
    }
    @IBAction func didClickVerify(_ sender: UIButton) {
        let (isValid, errorMessage) = checkCodeFields()
        if !isValid {
            Utils.shared.makeToast(message: errorMessage, vc: self)
        } else {
            let otp = "\(code1TextField.text ?? "")\(code2TextField.text ?? "")\(code3TextField.text ?? "")\(code4TextField.text ?? "")\(code5TextField.text ?? "")\(code6TextField.text ?? "")"
            let parameters: [String: Any] = ["name": "test","email": userEmailid,"countryCode":countryCode, "phoneNumber": Utils.shared.checkNullvalue(passedValue: userPhoneNumber), "otp": otp]
            
            Utils.shared.startLoaderAnimation(vc: self)
            ServiceManager.sharedInstance.executePostUrlWithDecodable(type: OTPValidationModel.self, with: UrlConstant.shared.otpValidation, params: parameters, showLoader: true, addAuth: false) { (result: AFDataResponse<OTPValidationModel>?, statusCode) in
                if statusCode == .success {
                    Utils.shared.stopLoadingAnimation()
                    if result?.value?.status == "success" {
                        if result?.value?.data?[0].message == "OTP is valid" {
                            Utils.shared.makeToast(message: "OTP is valid", vc: self)
                            _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.moveToChangePasswordScreen), userInfo: nil, repeats: false)
                        }
                    } else {
                        Utils.shared.makeToast(message: "Error occurred", vc: self)
                    }
                } else if statusCode == .unAuthorization {
                    Utils.shared.stopLoadingAnimation()
                    Utils.shared.makeToast(message: "Enter a valid user name and password to continue", vc: self)
                } else {
                    Utils.shared.stopLoadingAnimation()
                    Utils.shared.makeToast(message: "Enter valid otp to continue", vc: self)
                }
            }
        }
    }
    @objc func moveToChangePasswordScreen() {
        if let changePassword: ResetPasswordViewController = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVCID") as? ResetPasswordViewController {
            changePassword.userEmail = userEmailid
            changePassword.userCountryCode = countryCode
            changePassword.userPhoneNUmber = userPhoneNumber
            changePassword.modalPresentationStyle = .fullScreen
            self.present(changePassword, animated: true)
        }
    }
    @IBAction func didClickResendCode(_ sender: UIButton) {
        // Resend code
    }
}
extension OTPValidationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

            // Move to the next text field
            if string.count > 0 {
                if textField == code1TextField {
                    code1TextField.text = string
                    code2TextField.becomeFirstResponder()
                } else if textField == code2TextField {
                    code2TextField.text = string
                    code3TextField.becomeFirstResponder()
                } else if textField == code3TextField {
                    code3TextField.text = string
                    code4TextField.becomeFirstResponder()
                } else if textField == code4TextField {
                    code4TextField.text = string
                    code5TextField.becomeFirstResponder()
                } else if textField == code5TextField {
                    code5TextField.text = string
                    code6TextField.becomeFirstResponder()
                }
            }
            
            // Handle backspace
            if string.isEmpty && range.length == 1 {
                if textField == code6TextField {
                    code5TextField.becomeFirstResponder()
                } else if textField == code5TextField {
                    code4TextField.becomeFirstResponder()
                } else if textField == code4TextField {
                    code3TextField.becomeFirstResponder()
                } else if textField == code3TextField {
                    code2TextField.becomeFirstResponder()
                } else if textField == code2TextField {
                    code1TextField.becomeFirstResponder()
                }
            }

//            return currentText.count + string.count - range.length <= maxLength
        return true
    }
}
