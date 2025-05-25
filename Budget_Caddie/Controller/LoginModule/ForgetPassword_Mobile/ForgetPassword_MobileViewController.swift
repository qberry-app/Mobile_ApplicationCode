//
//  ForgetPassword_MobileViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 18/12/24.
//

import UIKit
import Alamofire
import CountryPickerView
class ForgetPassword_MobileViewController: UIViewController {

    @IBOutlet weak var phoneCode: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    var userEmail: String?
    let cpv = CountryPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        cpv.frame = view.bounds
        cpv.dataSource = self
        cpv.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didClickPhoneCodeButton(_ sender: UIButton) {
        cpv.showCountriesList(from: self)
    }
    
    @IBAction func didClickClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didClickSendOTPButton(_ sender: UIButton) {
        if phoneNumberTextField.text?.count == 0 {
            Utils.shared.makeToast(message: "Phone number cannot be Empty!!!", vc: self)
        } else {
            Utils.shared.startLoaderAnimation(vc: self)
            let parameters: [String: Any] = ["countryCode": Utils.shared.checkNullvalue(passedValue: phoneCode.text) ,"phoneNumber":Utils.shared.checkNullvalue(passedValue: phoneNumberTextField.text)]
            
            ServiceManager.sharedInstance.executePostUrlWithDecodable(type: LoginApiModel.self, with: UrlConstant.shared.forgetPassword, params: parameters, showLoader: true, addAuth: false) { (result: AFDataResponse<LoginApiModel>?, statusCode) in
                if statusCode == .success {
                    Utils.shared.stopLoadingAnimation()
                    if result?.value?.status == "success" {
                        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.moveToOTPVerificationScreen), userInfo: nil, repeats: false)
                        Utils.shared.swiftMessageAlert(theme: .info, message: "OTP has been sent successfully", view: self.view, titleMessage: "Success!!!")
                    }
                } else if statusCode == .unAuthorization {
                    Utils.shared.stopLoadingAnimation()
                    Utils.shared.makeToast(message: "Enter a valid user name and password to continue", vc: self)
                }
            }
        }
    }
    @objc func moveToOTPVerificationScreen() {
        if let otpValidationScreen: OTPValidationViewController = storyboard?.instantiateViewController(withIdentifier: "OTPValidationVCID") as? OTPValidationViewController {
            otpValidationScreen.countryCode = phoneCode.text ?? ""
            otpValidationScreen.userEmailid = userEmail ?? ""
            otpValidationScreen.userPhoneNumber = phoneNumberTextField.text ?? ""
            otpValidationScreen.modalPresentationStyle = .fullScreen
            self.present(otpValidationScreen, animated: true)
        }
    }
}
extension ForgetPassword_MobileViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print(country)
        self.phoneCode.text = (country.phoneCode)
    }
    
}
extension ForgetPassword_MobileViewController: CountryPickerViewDataSource {
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
}
