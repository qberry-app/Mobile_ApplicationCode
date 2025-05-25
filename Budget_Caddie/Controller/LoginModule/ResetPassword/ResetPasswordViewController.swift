//
//  ResetPasswordViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 18/12/24.
//

import UIKit
import Alamofire
class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var newPassword: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var newPasswordEyeButton: UIButton!
    
    @IBOutlet weak var confirmPasswordEyeButton: UIButton!
    var userEmail: String?
    var userCountryCode: String?
    var userPhoneNUmber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newPasswordEyeButton.setImage(UIImage.init(named: "EyeHide"), for: .normal)
        confirmPasswordEyeButton.setImage(UIImage.init(named: "EyeHide"), for: .normal)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didClickClose(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didClickNewPasswordEyeButton(_ sender: UIButton) {
        if newPasswordEyeButton.currentImage == UIImage.init(named: "EyeHide") {
            newPasswordEyeButton.setImage(UIImage.init(named: "EyeShow"), for: .normal)
            newPassword.isSecureTextEntry = false
        } else {
            newPassword.isSecureTextEntry = true
            newPasswordEyeButton.setImage(UIImage.init(named: "EyeHide"), for: .normal)
        }
    }
    
    @IBAction func didClickConfirmPasswordEyeButton(_ sender: UIButton) {
        if confirmPasswordEyeButton.currentImage == UIImage.init(named: "EyeHide") {
            confirmPasswordEyeButton.setImage(UIImage.init(named: "EyeShow"), for: .normal)
            confirmPassword.isSecureTextEntry = false
        } else {
            confirmPassword.isSecureTextEntry = true
            confirmPasswordEyeButton.setImage(UIImage.init(named: "EyeHide"), for: .normal)
        }
    }
    func validatePassword() -> (Bool, String) {
        if newPassword.text?.count == 0 {
            return (false, "Please enter new password")
        } else if confirmPassword.text?.count == 0{
            return (false, "Please enter new password")
        } else if newPassword.text != confirmPassword.text {
            return (false, "Password does not match")
        } else if !Utils.shared.isValidPassword(passwordText: newPassword.text ?? "") {
            return (false, "Enter a valid new password")
        } else if !Utils.shared.isValidPassword(passwordText: confirmPassword.text ?? "") {
            return (false, "Enter a valid confirm password")
        } else {
            return (true, "")
        }
    }
    @IBAction func didClickChangePassword(_ sender: UIButton) {
        let (valid, error) = validatePassword()
        if !valid {
            Utils.shared.makeToast(message: error, vc: self)
        } else {
            Utils.shared.startLoaderAnimation(vc: self)
            let parameters: [String: Any] = ["email":Utils.shared.checkNullvalue(passedValue: userEmail), "name":"Test1", "countryCode": Utils.shared.checkNullvalue(passedValue: userCountryCode), "phoneNumber": Utils.shared.checkNullvalue(passedValue: userPhoneNUmber),"password": Utils.shared.checkNullvalue(passedValue: newPassword.text)]
            ServiceManager.sharedInstance.executePostUrlWithDecodable(type: LoginApiModel.self, with: UrlConstant.shared.changePassword, params: parameters, showLoader: true) { (result: AFDataResponse<LoginApiModel>?, statusCode) in
                if statusCode == .success {
                    Utils.shared.stopLoadingAnimation()
                    if result?.value?.status == "success" {
                        Utils.shared.swiftMessageAlert(theme: .success, message: "Password changed successfully", view: self.view, titleMessage: "Success!!!")
                        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.moveToLoginScreen), userInfo: nil, repeats: false)
                    }
                } else if statusCode == .unAuthorization {
                    Utils.shared.stopLoadingAnimation()
                    Utils.shared.makeToast(message: "Enter a valid user name and password to continue", vc: self)
                }
            }
        }
    }
    
    @objc func moveToLoginScreen() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.makeLoginAsRootViewController()
    }

}
