//
//  OnBoardingViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 17/02/25.
//

import UIKit
import Alamofire

class OnBoardingViewController: UIViewController {

    @IBOutlet weak var progressIndicatorView: ALProgressBar!
    @IBOutlet weak var questionCountLbl: UILabel!
    @IBOutlet weak var onBoardingPageTitleLbl: UILabel!
    @IBOutlet weak var onBoardingTableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backwordButton: UIButton!
    var currentPageIndex:Int = 0
    var onBoardingDataArray:OnBoardingModel = OnBoardingModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backwordButton.isHidden = true
        progressIndicatorView.setProgress(0.0, animated: true)
        progressIndicatorView.startColor = .systemBlue
        progressIndicatorView.endColor = .systemGreen
        registerCurrentTableData()
        
    }
    func registerCurrentTableData() {
        let previousSelections = onBoardingDataArray.selectedList
        switch currentPageIndex {
        case 0:
            onBoardingDataArray = OnBoardingModel(title: "Hi Max, How'd you hear about us?",description: ["Online Search", "App store", "Friends, family or colleague", "Influencer"])
            progressIndicatorView.setProgress(0.1, animated: true)
            continueButton.setTitle("Next", for: .normal)
        case 1:
            onBoardingDataArray = OnBoardingModel(title: "How do you feel about your finance today?",description: ["😩 Stressed-I want to hide", "🫤 Unsure-Not much direction ", "😊Stable-No fires to put out", "😄Confident-Ready for my TED talk"])
            progressIndicatorView.setProgress(0.2, animated: true)
            continueButton.setTitle("Next", for: .normal)
        case 2:
            onBoardingDataArray = OnBoardingModel(title: "🏠Tell us about your home",description: ["I Rent", "I Own", "Other"])
            progressIndicatorView.setProgress(0.3, animated: true)
            continueButton.setTitle("Next", for: .normal)
        case 3:
            onBoardingDataArray = OnBoardingModel(title: "Do you currently have any debt?",description: ["💳 Credit card", "🎓 Student loan", "🚗 Auto loan", "💰 Personal loan", "🏥 Medical Debt"], footerDescription: "I don't currently have debt")
            progressIndicatorView.setProgress(0.4, animated: true)
            continueButton.setTitle("Next", for: .normal)
        case 4:
            onBoardingDataArray = OnBoardingModel(title: "How do you get around?",description: ["🚗 car", "🚝 Public Transit", "🚙 Rideshare (Uber/Lyft/etc.)", "🚲 Bike", "👟 Walk"], footerDescription: "None of these apply to me")
            progressIndicatorView.setProgress(0.5, animated: true)
            continueButton.setTitle("Next", for: .normal)
        case 5:
            onBoardingDataArray = OnBoardingModel(title: "🍿 Which of these subscriptions do you have",description: ["🎵 Music", "📺 TV Streaming", "💪 Fitness", "🎓 Online courses", "📖 Audio or ebooks", "📰 News", "🥗 Meal delivery",], footerDescription: "I don't subscribe to any of these")
            progressIndicatorView.setProgress(0.6, animated: true)
            continueButton.setTitle("Next", for: .normal)
        case 6:
            onBoardingDataArray = OnBoardingModel(title: "🤑 what major savings goals do you have ",description: ["🚙 New car", "🏡 Down payment for home", "🏝️ Vacation fund", "‼️ Emergency fund", "💁 Other"])
            progressIndicatorView.setProgress(0.8, animated: true)
            continueButton.setTitle("Next", for: .normal)
        case 7:
            onBoardingDataArray = OnBoardingModel(title: "Estimated annual income before taxes",description: ["< $10,000 ", " < $10,000 - $40,000 ", " < $40,000 - $60,000 ", " < $60,000 - $80,000 ", " < $80,000 - $100,000 ", " < $100,000 + "])
            progressIndicatorView.setProgress(0.9, animated: true)
            continueButton.setTitle("Continue", for: .normal)
        default: break
        }
        onBoardingDataArray.selectedList = previousSelections
        
        registerTableCell()
        backwordButton.isHidden = (currentPageIndex == 0)
        
        onBoardingPageTitleLbl.text = onBoardingDataArray.title
        questionCountLbl.text = "\(currentPageIndex) of 8 completed"
    }
    func registerTableCell() {
        self.onBoardingTableView.register(UINib(nibName: "OnBoardingTableViewCell",
                                               bundle: nil), forCellReuseIdentifier: "OnBoardingTableViewCell")
        self.onBoardingTableView.register(UINib(nibName: "MyFriendsListTableViewFooterCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "MyFriendsListTableViewFooterCell")
        self.onBoardingTableView.rowHeight = 92.0
        self.onBoardingTableView.estimatedRowHeight = 92.0
        self.onBoardingTableView.dataSource = self
        self.onBoardingTableView.delegate = self
        self.onBoardingTableView.separatorStyle = .none
        self.onBoardingTableView.reloadData()
    }
    @IBAction func didClickBackButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didClickBackwordButton(_ sender: UIButton) {
        if currentPageIndex != 0 {
            currentPageIndex = currentPageIndex - 1
            registerCurrentTableData()
        }
    }
    
    @IBAction func didClickContinueButton(_ sender: UIButton) {
        if let selectedData = onBoardingDataArray.selectedList.first(where: { $0.currentIndex == currentPageIndex }),
           !selectedData.selectedItemIndices!.isEmpty {
                // Proceed if at least one item is selected
                if currentPageIndex != 7 {
                    currentPageIndex += 1
                    registerCurrentTableData()
                } else {
                    Utils.shared.startLoaderAnimation(vc: self)
                    let param:[String: String] = ["HowYouHear": Utils.shared.checkNullvalue(passedValue: onBoardingDataArray.selectedList[0].selectedTexts?.joined(separator: ",")),
                                                  "FeelAboutFinance": Utils.shared.checkNullvalue(passedValue: onBoardingDataArray.selectedList[1].selectedTexts?.joined(separator: ",")),
                                                  "home":Utils.shared.checkNullvalue(passedValue: onBoardingDataArray.selectedList[2].selectedTexts?.joined(separator: ",")),
                                                  "userDebt": Utils.shared.checkNullvalue(passedValue: onBoardingDataArray.selectedList[3].selectedTexts?.joined(separator: ",")),
                                                  "userGetAround": Utils.shared.checkNullvalue(passedValue: onBoardingDataArray.selectedList[4].selectedTexts?.joined(separator: ",")),
                                                  "userSubscriptions": Utils.shared.checkNullvalue(passedValue: onBoardingDataArray.selectedList[5].selectedTexts?.joined(separator: ",")),
                                                  "UserMajorSavings": Utils.shared.checkNullvalue(passedValue: onBoardingDataArray.selectedList[6].selectedTexts?.joined(separator: ",")),
                                                  "userAnnualIncome": Utils.shared.checkNullvalue(passedValue: onBoardingDataArray.selectedList[7].selectedTexts?.joined(separator: ","))]
                    let auth = AuthCredentials(username: UserDefaultsHandler.shared.getUserEmail() ?? "nalini@gmail.com", password: UserDefaultsHandler.shared.getUserPassword() ?? "Test@123")
                    ServiceManager.sharedInstance.executePostUrlWithDecodable(type: LoginApiModel.self, with: UrlConstant.shared.saveOnBoardingDetails, params: param, auth: auth, showLoader: true) { (result: AFDataResponse<LoginApiModel>?, statusCode) in
                            if statusCode == .success {
                                Utils.shared.stopLoadingAnimation()
                                self.checkUserDetails()
                            } else {
                                Utils.shared.stopLoadingAnimation()
                                Utils.shared.makeToast(message: "Error in adding data", vc: self)
                            }
                        }
                    // Proceed to Next page
                   
                }
            } else {
                // Show error if no item is selected
                Utils.shared.swiftMessageAlert(theme: .error, message: "Please select at least one option", view: self.view, titleMessage: "Error")
            }
    }
    func checkUserDetails() {
        Utils.shared.startLoaderAnimation(vc: self)
        let auth = AuthCredentials(username: UserDefaultsHandler.shared.getUserEmail() ?? "nalini@gmail.com", password: UserDefaultsHandler.shared.getUserPassword() ?? "Test@123")
        ServiceManager.sharedInstance.executeGetUrlWithDecodable(type: UserDetailsApiModel.self, with: UrlConstant.shared.getUserDetails,auth: auth, showLoader: true) { (result: AFDataResponse<UserDetailsApiModel>?, statusCode) in
            if statusCode == .success {
                Utils.shared.stopLoadingAnimation()
                if result?.value?.status == "success" {
                    if Utils.shared.checkNullvalue(passedValue: result?.value?.data?[0].userName) == "" || Utils.shared.checkNullvalue(passedValue: result?.value?.data?[0].profilePictureUrl) == "" {
                        // User name not assigned
                    } else if result?.value?.data?[0].hasActiveSubscription == false {
                        // Move to subscription screen
                        let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HowItWorksVCID") as! HowItWorksViewController
                        profileViewController.modalPresentationStyle = .fullScreen
                        self.present(profileViewController, animated: true)
                    } else {
                        // Move to Dashboard screen
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.makeRootViewController()
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
    @IBAction func didClickForwardButton(_ sender: Any) {
        currentPageIndex = currentPageIndex + 1
        registerCurrentTableData()
    }
    @objc func handleNoActionTapped() {
        // Share Button Action

    }
}
extension OnBoardingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onBoardingDataArray.description.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = onBoardingTableView.dequeueReusableCell(withIdentifier: "OnBoardingTableViewCell") as? OnBoardingTableViewCell {
                cell.selectionStyle = .none
                let data = onBoardingDataArray.description[indexPath.row]

                // Check if the current page has selections
                if let selectedData = onBoardingDataArray.selectedList.first(where: { $0.currentIndex == currentPageIndex }) {
                    if selectedData.selectedItemIndices!.contains(indexPath.row) {
                        cell.contentSelectionImage.image = UIImage(named: "CheckboxChecked")
                    } else {
                        cell.contentSelectionImage.image = UIImage(named: "CheckboxUnchecked")
                    }
                } else {
                    cell.contentSelectionImage.image = UIImage(named: "CheckboxUnchecked")
                }

                cell.contentText.text = Utils.shared.checkNullvalue(passedValue: data)
                return cell
            }
            return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension OnBoardingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedListData: OnBoardDataModel?
            // Check if there's already selected data for the current page
            if let existingDataIndex = onBoardingDataArray.selectedList.firstIndex(where: { $0.currentIndex == currentPageIndex }) {
                selectedListData = onBoardingDataArray.selectedList[existingDataIndex]
            } else {
                selectedListData = OnBoardDataModel(currentIndex: currentPageIndex, selectedItemIndices: [], selectedTexts: [])
                onBoardingDataArray.selectedList.append(selectedListData!)
            }
        guard var selectedData = selectedListData else { return }
            // Toggle selection
        if let existingIndex = selectedData.selectedItemIndices?.firstIndex(of: indexPath.row) {
                // If already selected, remove it
            selectedData.selectedItemIndices?.remove(at: existingIndex)
            selectedData.selectedTexts?.remove(at: existingIndex)
            } else {
                // If not selected, add it
                selectedData.selectedItemIndices?.append(indexPath.row)
                selectedData.selectedTexts?.append(onBoardingDataArray.description[indexPath.row])
            }
            // Update stored selection
            if let existingDataIndex = onBoardingDataArray.selectedList.firstIndex(where: { $0.currentIndex == currentPageIndex }) {
                onBoardingDataArray.selectedList[existingDataIndex] = selectedData
            }
            tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if !onBoardingDataArray.footerDescription.isEmpty {
            let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MyFriendsListTableViewFooterCell") as! MyFriendsListTableViewFooterCell
            headerCell.shareButton.addTarget(self, action: #selector(handleNoActionTapped), for: .touchUpInside)
            headerCell.shareButton.setTitle(onBoardingDataArray.footerDescription, for: .normal)
            headerCell.shareButton.titleLabel?.textAlignment = .left
            return headerCell
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if !onBoardingDataArray.footerDescription.isEmpty {
            return 60.0
        } else {
            return 0.0
        }
    }
}
struct OnBoardingModel {
    var title: String = String()
    var description: [String] = [String]()
    var footerDescription: String = String()
    var cellSelectedIndex: Int = -1
    var selectedList:[OnBoardDataModel] = [OnBoardDataModel]()
}
struct OnBoardDataModel {
    var currentIndex: Int?
    var selectedItemIndices: [Int]?
    var selectedTexts: [String]?
}
