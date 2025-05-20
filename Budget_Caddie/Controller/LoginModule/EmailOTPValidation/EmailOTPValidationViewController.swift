//
//  EmailOTPValidationViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 18/12/24.
//

import UIKit
import Alamofire
class EmailOTPValidationViewController: UIViewController {

    @IBOutlet weak var verificationCodeTextField: UITextField!
    var userEmail: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didClickBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didClickVerifyButton(_ sender: UIButton) {
        if verificationCodeTextField.text?.count == 0 {
            showAlert(with: "Error!!!", message: "Please enter code")
        } else if verificationCodeTextField.text?.count ?? 2 < 4 {
            showAlert(with: "Error!!!", message: "Please enter a valid code")
        } else {
            Utils.shared.startLoaderAnimation(vc: self)
            let parameters: [String: Any] = ["email":Utils.shared.checkNullvalue(passedValue: userEmail), "name":"Test1", "otp": Utils.shared.checkNullvalue(passedValue: verificationCodeTextField.text)]
            ServiceManager.sharedInstance.executePostUrlWithDecodable(type: OTPValidationModel.self, with: UrlConstant.shared.otpValidation, params: parameters, showLoader: true) { (result: AFDataResponse<OTPValidationModel>?, statusCode) in
                if statusCode == .success {
                    Utils.shared.stopLoadingAnimation()
                    if result?.value?.status == "success" {
                        Utils.shared.makeToast(message: "OTP is valid", vc: self)
                        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.moveToChangePasswordScreen), userInfo: nil, repeats: false)
                    }
                } else if statusCode == .unAuthorization {
                    Utils.shared.stopLoadingAnimation()
                    Utils.shared.makeToast(message: "Enter a valid user name and password to continue", vc: self)
                }
            }
        }
    }
    
    @objc func moveToChangePasswordScreen() {
        if let changePassword: ResetPasswordViewController = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVCID") as? ResetPasswordViewController {
            changePassword.userEmail = self.userEmail
            changePassword.modalPresentationStyle = .fullScreen
            self.present(changePassword, animated: true)
        }
    }

}
