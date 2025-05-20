//
//  ForgetPassword_EmailViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 18/12/24.
//

import UIKit
import Alamofire
class ForgetPassword_EmailViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    var email: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didClickClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didClickSendMailButton(_ sender: UIButton) {
        if emailTextField.text?.count == 0 {
            Utils.shared.makeToast(message: "Email cannot be Empty!!!", vc: self)
        } else if !(Utils.shared.isValidEmail(emailTextField.text ?? "")) {
            Utils.shared.makeToast(message: "Enter a valid Email", vc: self)
        } else {
            Utils.shared.startLoaderAnimation(vc: self)
            let parameters: [String: Any] = ["email":Utils.shared.checkNullvalue(passedValue: emailTextField.text)]
            ServiceManager.sharedInstance.executePostUrlWithDecodable(type: LoginApiModel.self, with: UrlConstant.shared.forgetPassword, params: parameters, showLoader: true) { (result: AFDataResponse<LoginApiModel>?, statusCode) in
                if statusCode == .success {
                    if result?.value?.status == "success" {
                        Utils.shared.stopLoadingAnimation()
                        Utils.shared.swiftMessageAlert(theme: .info, message: "OTP send successfully.", view: self.view, titleMessage: "Success!!!")
                        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.moveToEmailOTPvalidation), userInfo: nil, repeats: false)
                    } else {
                        Utils.shared.stopLoadingAnimation()
                        Utils.shared.makeToast(message: "Error while sending Email", vc: self)
                    }
                } else if statusCode == .unAuthorization {
                    Utils.shared.stopLoadingAnimation()
                    Utils.shared.makeToast(message: "Enter a valid data to continue", vc: self)
                } else if statusCode == .serviceUnavailable {
                    Utils.shared.stopLoadingAnimation()
                    Utils.shared.swiftMessageAlert(theme: .error, message: "Email id does not exist", view: self.view, titleMessage: "Failed!!!")
                }
            }
            
        }
    }
    
    @objc func moveToEmailOTPvalidation() {
        if let emailOTPvc: EmailOTPValidationViewController = storyboard?.instantiateViewController(withIdentifier: "EmailOTPVCID") as? EmailOTPValidationViewController {
            emailOTPvc.userEmail = emailTextField.text ?? ""
            emailOTPvc.modalPresentationStyle = .fullScreen
            self.present(emailOTPvc, animated: true)
        }
    }
}
