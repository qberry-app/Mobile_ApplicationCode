//
//  DashboardViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 24/12/24.
//

import UIKit
import JXSegmentedView

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var mainSubView: UIView!
    
    @IBOutlet weak var dashboardScrollView: UIScrollView!
    @IBOutlet weak var subViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabBarViewController: JXSegmentedView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    var headerDataSource = JXSegmentedTitleDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarViewController.delegate = self
        
        headerDataSource.titles = ["Dashboard","Goals","Create Category", "Shared Budget","Add Transactions"]
//        headerDataSource.isTitleZoomEnabled = true
        headerDataSource.isTitleColorGradientEnabled = true
        headerDataSource.isSelectedAnimable = true
        headerDataSource.isItemWidthZoomAnimable = true
        headerDataSource.selectedAnimationDuration = 0.1
        headerDataSource.isTitleColorGradientEnabled = true
        headerDataSource.titleSelectedColor = .red
        tabBarViewController.dataSource = self.headerDataSource
        
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorColor = .red
        indicator.isScrollEnabled = true
        indicator.indicatorPosition = .bottom
        indicator.indicatorHeight = 2 // Set the height of the underline
        indicator.indicatorWidth = 40 // Set the width of the underline
        tabBarViewController.indicators = [indicator]
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
        let dashboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTransactionVCID") as! AddTransactionViewController
        addControllerToSubview(controller: dashboard)
        adjustScrollViewHeight(controller: dashboard)
       
    }
    
    @IBAction func didClickProfile(_ sender: UIButton) {
        print("Profile clicked")
//        let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVCID") as! ProfileViewController
//        profileViewController.modalPresentationStyle = .fullScreen
//        self.present(profileViewController, animated: true)
    }
    
    @IBAction func didClickDateMovingForward(_ sender: UIButton) {
        print("Foward button clicked")
    }
    @IBAction func didClickDateMovingBackward(_ sender: UIButton) {
        print("Backword button clicked")
    }
    private func adjustScrollViewHeight(controller: UIViewController) {
            if let scrollView = controller.view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
                let contentHeight = scrollView.contentSize.height
                print("ScrollView Content Height: \(contentHeight)")
                // Adjust the height constraint or handle as needed
                mainSubView.frame.size.height = contentHeight
            }
        }
    private func addControllerToSubview(controller: UIViewController) {
            for subview in mainSubView.subviews {
                subview.removeFromSuperview()
            }
            
            addChild(controller)
            mainSubView.addSubview(controller.view)
            controller.view.frame = mainSubView.bounds
            controller.didMove(toParent: self)
        }
    
    @IBAction func didClickFriendsNotificationView(_ sender: UIButton) {
//        let friendsListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FriendsListVCID") as! FriendsListViewController
//        friendsListVC.modalPresentationStyle = .fullScreen
//        self.present(friendsListVC, animated: true)
    }
}
extension DashboardViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        let dashboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GoalsListVCID") as! GoalsListViewController
        let addTransaction = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTransactionVCID") as! AddTransactionViewController
        let createCategory = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateCategoryViewController") as! CreateCategoryViewController
        let goalController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GoalsListVCID") as? GoalsListViewController
        if index == 0 {
            addControllerToSubview(controller: dashboard)
            adjustScrollViewHeight(controller: dashboard)
        } else if index == 1 {
            addControllerToSubview(controller: goalController!)
            adjustScrollViewHeight(controller: goalController!)
        } else if index == 2 {
            addControllerToSubview(controller: createCategory)
            adjustScrollViewHeight(controller: createCategory)
        } else if index == 3 {
            addControllerToSubview(controller: createCategory)
            adjustScrollViewHeight(controller: createCategory)
        } else {
            addTransaction.isFromDashboard = true
            addControllerToSubview(controller: addTransaction)
            adjustScrollViewHeight(controller: addTransaction)
        }
    }
}
extension DashboardViewController: JXSegmentedViewDataSource {
    func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        return JXSegmentedBaseCell()
        
    }
    
    
    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int) {
        
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        
    }
    
    var isItemWidthZoomEnabled: Bool {
        return true
    }
    
    var selectedAnimationDuration: TimeInterval {
        return 0
    }
    
    var itemSpacing: CGFloat {
        return 1
    }
    
    var isItemSpacingAverageEnabled: Bool {
        return true
    }
    
    func reloadData(selectedIndex: Int) {
        
    }
    
    func itemDataSource(in segmentedView: JXSegmentedView) -> [JXSegmentedBaseItemModel] {
        return []
    }
    
    func registerCellClass(in segmentedView: JXSegmentedView) {
        
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, widthForItemAt index: Int) -> CGFloat {
        return 100
    }
    func segmentedView(_ segmentedView: JXSegmentedView, widthForItemContentAt index: Int) -> CGFloat {
        return 50
    }
    
    func refreshItemModel(_ segmentedView: JXSegmentedView, _ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        
    }
    
    func refreshItemModel(_ segmentedView: JXSegmentedView, currentSelectedItemModel: JXSegmentedBaseItemModel, willSelectedItemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        
    }
    
    func refreshItemModel(_ segmentedView: JXSegmentedView, leftItemModel: JXSegmentedBaseItemModel, rightItemModel: JXSegmentedBaseItemModel, percent: CGFloat) {
        
    }
   
    
    func segmentedView(_ segmentedView: JXSegmentedView, titleAt index: Int) -> String {
        return "Tab \(index)"
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
}


