//
//  LoginViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 17/12/24.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var rememberMeButton: CustomButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordShowHideButton: UIButton!
    var rememberMeButtonChecked: Bool = false
    var isFromSignup:Bool = false
    var passwordTextFromSignup: String = String()
    var emailTextFromSignup: String = String()
    var userDetailsApiModel: UserDetailsApiModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordShowHideButton.setImage(UIImage.init(named: "EyeHide"), for: .normal)
        rememberMeButton.setImage(UIImage.init(named: "CheckboxUnchecked"), for: .normal)
        if isFromSignup {
            passwordTextField.text = Utils.shared.checkNullvalue(passedValue: passwordTextFromSignup)
            userNameTextField.text = Utils.shared.checkNullvalue(passedValue: emailTextFromSignup)
        }
    }
    @IBAction func didClickPasswordShow(_ sender: UIButton) {
        if passwordShowHideButton.currentImage == UIImage.init(named: "EyeHide") {
            passwordShowHideButton.setImage(UIImage.init(named: "EyeShow"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordShowHideButton.setImage(UIImage.init(named: "EyeHide"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func resetPasswordButton(_ sender: UIButton) {
        if Utils.shared.checkNullvalue(passedValue: userNameTextField.text) == "" {
            Utils.shared.makeToast(message: "Please enter email to reset password ", vc: self)
        } else {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResetTypeVCID") as? ResetTypeViewController {
                vc.userEmail = Utils.shared.checkNullvalue(passedValue: userNameTextField.text)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
    }
    @IBAction func didClickSignupAction(_ sender: UIButton) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupVCID") as? SignupViewController {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    func checkLoginFields() -> (Bool, String) {
        if userNameTextField.text?.isEmpty ?? true  {
            return (false, "User Name cannot be empty")
        } else if passwordTextField.text?.isEmpty ?? true {
            return (false, "Password cannot be empty")
        } else {
            return (true, "")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVc =  segue.destination as? ResetTypeViewController
            destinationVc?.userEmail = Utils.shared.checkNullvalue(passedValue: userNameTextField.text)
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "MoveToSignup" {
            return true
        } else {
            if Utils.shared.checkNullvalue(passedValue: userNameTextField.text) == "" {
                Utils.shared.makeToast(message: "Please enter email to reset password ", vc: self)
                return false
            } else {
                return true
            }
        }
        return false
    }
    
    func checkOnboardningAdded() {
        Utils.shared.startLoaderAnimation(vc: self)
        let auth = AuthCredentials(username: UserDefaultsHandler.shared.getUserEmail() ?? "nalini@gmail.com", password: UserDefaultsHandler.shared.getUserPassword() ?? "Test@123")
        ServiceManager.sharedInstance.executeGetUrlWithDecodable(type: OnboardingDetailsModel.self, with: UrlConstant.shared.getOnboardingDetails, auth: auth, showLoader: true) { (result: AFDataResponse<OnboardingDetailsModel>?, statusCode) in
            if statusCode == .success {
                Utils.shared.stopLoadingAnimation()
                if result?.value?.status == "success" {
                    if let responseData = result?.value?.data?.first {
                        if Utils.shared.checkNullvalue(passedValue: responseData.howYouHear) == "" ||
                            Utils.shared.checkNullvalue(passedValue: responseData.home) == "" ||
                            Utils.shared.checkNullvalue(passedValue: responseData.userDebt) == "" ||
                            Utils.shared.checkNullvalue(passedValue: responseData.userGetAround) == "" ||
                            Utils.shared.checkNullvalue(passedValue: responseData.userSubscriptions) == "" ||
                            Utils.shared.checkNullvalue(passedValue: responseData.userAnnualIncome) == "" ||
                            Utils.shared.checkNullvalue(passedValue: responseData.userMajorSavings) == "" ||
                            Utils.shared.checkNullvalue(passedValue: responseData.feelAboutFinance) == "" {
                            self.moveToOnboardingScreen()
                        } else {
                            if self.userDetailsApiModel.data?.first?.hasActiveSubscription == false {
                                self.moveToSubscriptionScreen()
                            } else if self.userDetailsApiModel.data?.first?.userName ?? "" == "" || self.userDetailsApiModel.data?.first?.profilePictureUrl ?? "" == "" {
                                self.moveToChooseUserNameScreen(userProfileImage:self.userDetailsApiModel.data?.first?.profilePictureUrl ?? "", userName: self.userDetailsApiModel.data?.first?.userName ?? "")
                            } else {
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.makeRootViewController()
                            }
                           
                        }
                    }
                }
            } else {
                Utils.shared.stopLoadingAnimation()
            }
        }
    }
    
    func checkUserDetails() {
        Utils.shared.startLoaderAnimation(vc: self)
        let auth = AuthCredentials(username: UserDefaultsHandler.shared.getUserEmail() ?? "nalini@gmail.com", password: UserDefaultsHandler.shared.getUserPassword() ?? "Test@123")
        ServiceManager.sharedInstance.executeGetUrlWithDecodable(type: UserDetailsApiModel.self, with: UrlConstant.shared.getUserDetails,auth: auth, showLoader: true) { (result: AFDataResponse<UserDetailsApiModel>?, statusCode) in
            if statusCode == .success {
                Utils.shared.stopLoadingAnimation()
                if result?.value?.status == "success" {
                    self.userDetailsApiModel = result?.value
                    if Utils.shared.checkNullvalue(passedValue: result?.value?.data?[0].userName) == "" || Utils.shared.checkNullvalue(passedValue: result?.value?.data?[0].profilePictureUrl) == "" {
                        self.moveToChooseUserNameScreen(userProfileImage: result?.value?.data?[0].profilePictureUrl ?? "", userName: result?.value?.data?[0].userName ?? "")
                    } else if result?.value?.data?[0].hasActiveSubscription == false {
                        // Move to subscription screen
                        self.checkOnboardningAdded()
                    } else {
                        // Move to Dashboard screen
                        self.checkOnboardningAdded()
                    }
                    
                } else {
                    Utils.shared.makeToast(message: "error occurred", vc: self)
                }
            } else if statusCode == .unAuthorization {
                Utils.shared.stopLoadingAnimation()
                Utils.shared.makeToast(message: "Enter a valid user name and password to continue", vc: self)
            }
           
        }
    }
    @IBAction func didClickLogin(_ sender: UIButton) {
        let logincheck = checkLoginFields()
        if logincheck.0 {
            // Proceed with login
            Utils.shared.startLoaderAnimation(vc: self)
            let parameters: [String: Any] = ["email":Utils.shared.checkNullvalue(passedValue: userNameTextField.text),"password": Utils.shared.checkNullvalue(passedValue: passwordTextField.text)]
            ServiceManager.sharedInstance.executePostUrlWithDecodable(type: LoginApiModel.self, with: UrlConstant.shared.login, params: parameters, showLoader: true) { (result: AFDataResponse<LoginApiModel>?, statusCode) in
                if statusCode == .success {
                    Utils.shared.stopLoadingAnimation()
                    if result?.value?.status == "success" {
                            UserDefaultsHandler.shared.setUserEmail(Utils.shared.checkNullvalue(passedValue: self.userNameTextField.text))
                            UserDefaultsHandler.shared.setUserPassword(Utils.shared.checkNullvalue(passedValue: self.passwordTextField.text))

                        self.checkUserDetails()
                       
                    } else {
                        Utils.shared.makeToast(message: "error occurred", vc: self)
                    }
                } else if statusCode == .unAuthorization {
                    Utils.shared.stopLoadingAnimation()
                    Utils.shared.makeToast(message: "Enter a valid user name and password to continue", vc: self)
                }
            }
        } else {
            Utils.shared.makeToast(message: logincheck.1, vc: self)
        }
    }
    @IBAction func didClickRememberMe(_ sender: UIButton) {
        // Save the user in User defaults
        if rememberMeButton.currentImage == UIImage.init(named: "CheckboxUnchecked") {
            rememberMeButton.setImage(UIImage.init(named: "CheckboxChecked"), for: .normal)
            rememberMeButtonChecked = true
        } else {
            rememberMeButton.setImage(UIImage.init(named: "CheckboxUnchecked"), for: .normal)
            rememberMeButtonChecked = false
        }
    }
    func moveToChooseUserNameScreen(userProfileImage: String, userName: String) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Plaid_ImageUploadVCID") as? Plaid_ImageUploadViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.userProfileImageUrlFromApi = userProfileImage
            vc.userNameFromApi = userName
            self.present(vc, animated: true)
        }
    }
    func moveToSubscriptionScreen() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChooseSubscriptionVCID") as? ChooseSubscriptionViewController {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    func moveToOnboardingScreen() {
        let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
        profileViewController.modalPresentationStyle = .fullScreen
        self.present(profileViewController, animated: true)
        
    }
}
