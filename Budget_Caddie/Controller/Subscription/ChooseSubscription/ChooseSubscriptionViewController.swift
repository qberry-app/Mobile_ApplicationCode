//
//  ChooseSubscriptionViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 29/01/25.
//

import UIKit
import Alamofire
import LinkKit
protocol CustomPlaidDelegate: AnyObject {
    func didUpdateData(_ data: LinkSuccess)
}
class ChooseSubscriptionViewController: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var continueButton: CustomButton!
    @IBOutlet weak var subscriptionListTableView: UITableView!
    @IBOutlet weak var subscriptionLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var mainbackgroundImage: UIImageView!
    var subscriptionListArray: [SubscriptionList] = []
    var subList: SubscriptionList!
    var selectedTableIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = UIBezierPath(roundedRect:bottomView.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 20, height:  20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        bottomView.layer.mask = maskLayer
        subList = SubscriptionList()
        subList = SubscriptionList(subscriptionName: "One year", subscriptionPrice: "$189.99 / year", trialPeriod: "* Access to SAVI our AI chatbot",timePeriod: "* Real time transaction sync", offerEnabled: true, offerDetails: "You save 10%")
        subscriptionListArray.append(subList)
        subList = SubscriptionList()
        subList = SubscriptionList(subscriptionName: "One month", subscriptionPrice: "$19.99 / Month", trialPeriod: "* Access to SAVI our AI chatbot",timePeriod: "* Real time transaction sync", offerEnabled: false, offerDetails: "")
        subscriptionListArray.append(subList)
        self.registerTableViewcell()
    }
    func registerTableViewcell() {
        self.subscriptionListTableView.register(UINib(nibName: "ChooseSubscriptionTableViewCell",
                                               bundle: nil), forCellReuseIdentifier: "ChooseSubscriptionTableViewCell")
        self.subscriptionListTableView.delegate = self
        self.subscriptionListTableView.dataSource = self
        self.subscriptionListTableView.separatorStyle = .none
        self.subscriptionListTableView.rowHeight = 173
        self.subscriptionListTableView.estimatedRowHeight = 173
        self.subscriptionListTableView.reloadData()
    }
    @IBAction func didClickSkipButton(_ sender: UIButton) {
        // skip the transactions
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.makeRootViewController()
    }
    @IBAction func didClickContinueButton(_ sender: UIButton) {
        if selectedTableIndex == -1 {
            Utils.shared.makeToast(message: "Choose any one subscription option", vc: self)
        } else {
            self.hitChooseSubscriptionApi()
        }
    }
    @objc func moveToPlaidScreen() {
        Utils.shared.startLoaderAnimation(vc: self)
        let auth = AuthCredentials(username: UserDefaultsHandler.shared.getUserEmail() ?? "nalini@gmail.com", password: UserDefaultsHandler.shared.getUserPassword() ?? "Test@123")
        ServiceManager.sharedInstance.executeGetUrlWithDecodable(type: PlaidTokenModel.self, with: UrlConstant.shared.generatePlaidToken, auth: auth, showLoader: true) { (result: AFDataResponse<PlaidTokenModel>?, statusCode) in
            if statusCode == .success {
                Utils.shared.stopLoadingAnimation()
                if let plaidToken = result?.value {
                    let plaidHandler = PlaidHandler.shared
                    plaidHandler.delegate = self
                        PlaidHandler.shared.startPlaidHandle(vc: self, currentLinkToken: Utils.shared.checkNullvalue(passedValue: plaidToken.linkData?[0].linkToken))
                }
            } else {
                Utils.shared.stopLoadingAnimation()
            }
        }
    }
    func hitChooseSubscriptionApi() {
        let auth = AuthCredentials(username: UserDefaultsHandler.shared.getUserEmail() ?? "nalini@gmail.com", password: UserDefaultsHandler.shared.getUserPassword() ?? "Test@123")
        var selectedValue: String = ""
        if selectedTableIndex == 0 {
            selectedValue = "Yearly"
        } else {
            selectedValue = "Monthly"
        }
        let param:[String: Any] = ["plan": selectedValue]
        Utils.shared.startLoaderAnimation(vc: self)
        ServiceManager.sharedInstance.executePostUrlWithDecodable(type: LoginApiModel.self, with: UrlConstant.shared.saveUserSubscription, params: param,auth: auth, showLoader: true) { (result: AFDataResponse<LoginApiModel>?, statusCode) in
            if statusCode == .success {
                Utils.shared.stopLoadingAnimation()
                if result?.value?.status == "success" {
                    Utils.shared.swiftMessageAlert(theme: .success, message: "Subscribed successfully", view: self.view, titleMessage: "Success!!!")
                    _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.moveToPlaidScreen), userInfo: nil, repeats: false)
                } else {
                    Utils.shared.makeToast(message: "Error in adding subscription", vc: self)
                }
            } else {
                Utils.shared.stopLoadingAnimation()
                Utils.shared.makeToast(message: "Error in adding Subscription", vc: self)
            }
        }
    }
}
extension ChooseSubscriptionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = subscriptionListTableView.dequeueReusableCell(withIdentifier: "ChooseSubscriptionTableViewCell") as! ChooseSubscriptionTableViewCell
        cell.selectionStyle = .none
        let subListVar = subscriptionListArray[indexPath.section]
        cell.subscriptionPriceLabel.text = subListVar.subscriptionPrice
        cell.trialPeriodLabel.text = subListVar.trialPeriod
        cell.billingLabel.text = subListVar.timePeriod
        cell.subscriptionCheckBox.delegate = self
        cell.subscriptionCheckBox.onAnimationType = .oneStroke
        cell.subscriptionCheckBox.offAnimationType = .fill
        cell.subscriptionCheckBox.tag = indexPath.section
        if subListVar.offerEnabled ==  true {
            cell.offerLabel.isHidden = false
            cell.offerLabel.text = subListVar.offerDetails
        } else {
            cell.offerLabel.isHidden = true
        }
        if selectedTableIndex != -1 {
            if indexPath.section == selectedTableIndex {
                cell.subscriptionCheckBox.setOn(true, animated: true)
            } else {
                cell.subscriptionCheckBox.setOn(false)
            }
        }
        return cell

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return subscriptionListArray.count
    }
    
}
extension ChooseSubscriptionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTableIndex = indexPath.section
        subscriptionListTableView.reloadData()
    }
}
struct SubscriptionList {
    var subscriptionName: String?
    var subscriptionPrice: String?
    var trialPeriod: String?
    var timePeriod: String?
    var offerEnabled: Bool?
    var offerDetails: String?
}
extension ChooseSubscriptionViewController: BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox) {
        selectedTableIndex = checkBox.tag
        subscriptionListTableView.reloadData()
    }
    func animationDidStop(for checkBox: BEMCheckBox) {
        
    }
}
extension ChooseSubscriptionViewController : CustomPlaidDelegate {
    func didUpdateData(_ data: LinkSuccess) {
        print(data)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.makeRootViewController()
    }
}
