//
//  Plaid_ImageUploadViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 23/01/25.
//

import UIKit
import Photos
import Alamofire
import SDWebImage
class Plaid_ImageUploadViewController: UIViewController {

    @IBOutlet weak var successOrFailTickImage: UIImageView!
    @IBOutlet weak var enterReferalLinkTxtFld: UITextField!
    @IBOutlet weak var enterUserNameTxtFld: UITextField!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameTakenAvailableLbl: UILabel!
    var userProfileImageUrlFromApi: String = String()
    var userNameFromApi: String = String()
    var profileImage: String = String()
    private lazy var imagePicker: ImagePicker = {
            let imagePicker = ImagePicker()
            imagePicker.delegate = self
            return imagePicker
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        successOrFailTickImage.isHidden = true
        enterUserNameTxtFld.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.userProfileImage.layer.cornerRadius = self.userProfileImage.bounds.size.width / 2.0
          self.userProfileImage.clipsToBounds = true
        if userProfileImageUrlFromApi != "" {
            userProfileImage.sd_setImage(with: URL(string: userProfileImageUrlFromApi), placeholderImage: UIImage.init(named: "Placeholder"))
        } else if userNameFromApi != "" {
            enterUserNameTxtFld.isUserInteractionEnabled = false
            enterUserNameTxtFld.text = userNameFromApi
        }
    }
    @objc func textFieldDidChange() {
        if enterUserNameTxtFld.text == "" {
            //UserName is empty
            successOrFailTickImage.isHidden = true
        } else {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(userStoppedTyping), object: nil)
            self.perform(#selector(userStoppedTyping), with: nil, afterDelay: 1.0) // 1 second delay
        }
    }
       @objc func userStoppedTyping() {
           print("User stopped typing. Text: \(enterUserNameTxtFld.text ?? "")")
           checkUserNameAvailable(availableText: enterUserNameTxtFld.text ?? "")
       }
    
    func checkUserNameAvailable(availableText: String) {
        if availableText != "" {
            Utils.shared.startLoaderAnimation(vc: self)
            let auth = AuthCredentials(username: UserDefaultsHandler.shared.getUserEmail() ?? "nalini@gmail.com", password: UserDefaultsHandler.shared.getUserPassword() ?? "Test@123")
            let parameters: [String: Any] = ["userName":Utils.shared.checkNullvalue(passedValue: enterUserNameTxtFld.text)]
            ServiceManager.sharedInstance.executeGetUrlWithDecodable(type: LoginApiModel.self, with: UrlConstant.shared.checkUserNameAvailability,params: parameters, auth: auth, showLoader: true) { (result: AFDataResponse<LoginApiModel>?, statusCode) in
                if statusCode == .success {
                    Utils.shared.stopLoadingAnimation()
                    if result?.value?.status == "success" {
                        if Utils.shared.checkNullvalue(passedValue: result?.value?.data?[0]) == "username not available" {
                            self.userNameTakenAvailableLbl.isHidden = false
                            self.userNameTakenAvailableLbl.text = "User name is available"
                            self.userNameTakenAvailableLbl.textColor = UIColor.init(red: 0/255, green: 100/255, blue: 0/255, alpha: 1.0)
                            self.successOrFailTickImage.isHidden = false
                            self.successOrFailTickImage.image = UIImage(named: "SuccessTick")
                        } else {
                            self.userNameTakenAvailableLbl.isHidden = false
                            self.successOrFailTickImage.isHidden = false
                            self.successOrFailTickImage.image = UIImage(named: "UserAvailableImage")
                        }
                    }
                } else {
                    Utils.shared.stopLoadingAnimation()
                }
            }
        }
    }
    
    @IBAction func didClickUploadImage(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: .actionSheet)
                // Add camera option if device has camera
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
                        self?.imagePicker.cameraAsscessRequest()
                    }
                    alertController.addAction(cameraAction)
                }
                let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
                    self?.imagePicker.photoGalleryAsscessRequest()
                }
                alertController.addAction(libraryAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
                alertController.addAction(cancelAction)
                if let popoverController = alertController.popoverPresentationController {
                    popoverController.sourceView = enterUserNameTxtFld
                    popoverController.sourceRect = enterUserNameTxtFld.bounds
                }
                present(alertController, animated: true)
    }
    @IBAction func didClickBackButton(_ sender: UIButton) {
        self.dismiss(animated: true)
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
                            self.moveToOnboardningScreen()
                        } else {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.makeRootViewController()
                        }
                    }
                }
            } else {
                Utils.shared.stopLoadingAnimation()
            }
        }
    }
    
    func moveToOnboardningScreen() {
        
        let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
        profileViewController.modalPresentationStyle = .fullScreen
        self.present(profileViewController, animated: true)
        
    }
    @IBAction func didClickContinueButton(_ sender: UIButton) {
        if enterUserNameTxtFld.text == "" {
            Utils.shared.makeToast(message: "Please enter the user name", vc: self)
        } else if profileImage == "" {
            Utils.shared.makeToast(message: "Please upload your profile image", vc: self)
        } else {
            uploadUserNameImageToServer(imageUrl: profileImage)
            
        }
    }
}
extension Plaid_ImageUploadViewController: ImagePickerDelegate {
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool, to sourceType: UIImagePickerController.SourceType) {
        guard grantedAccess else { return }
                imagePicker.present(parent: self, sourceType: sourceType)
    }
    
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        userProfileImage.image = image
        AWSUploadManager.sharedInstance.UploadImageToAWSWithoutAnimation(uploadImage: image, viewController: self) { (imageUrl, Status) in
            if Status == 200 {
                print("FileName",imageUrl)
                self.profileImage = imageUrl
            } else {
                Utils.shared.makeToast(message: "Error uploading profile image", vc: self)
            }
        }
        imagePicker.dismiss()
    }
    
    func cancelButtonDidClick(on imageView: ImagePicker) {
        imagePicker.dismiss()
    }
    
}
extension Plaid_ImageUploadViewController {
    func uploadUserNameImageToServer(imageUrl: String) {
        Utils.shared.startLoaderAnimation(vc: self)
        let parameters: [String: Any] = ["userName":Utils.shared.checkNullvalue(passedValue: enterUserNameTxtFld.text),"profilePictureUrl": Utils.shared.checkNullvalue(passedValue: imageUrl), "referralCode": Utils.shared.checkNullvalue(passedValue: enterReferalLinkTxtFld.text)]
        let auth = AuthCredentials(username: UserDefaultsHandler.shared.getUserEmail() ?? "nalini@gmail.com", password: UserDefaultsHandler.shared.getUserPassword() ?? "Test@123")
        ServiceManager.sharedInstance.executePostUrlWithDecodable(type: LoginApiModel.self, with: UrlConstant.shared.saveUserImage_Name, params: parameters,auth: auth, showLoader: true) { (result: AFDataResponse<LoginApiModel>?, statusCode) in
            if statusCode == .success {
                Utils.shared.stopLoadingAnimation()
                if result?.value?.status == "success" {
                    self.checkOnboardningAdded()
                }
            } else if statusCode == .unAuthorization {
                Utils.shared.stopLoadingAnimation()
                Utils.shared.makeToast(message: "Enter a valid user name and password to continue", vc: self)
            }
        }
    }
}
