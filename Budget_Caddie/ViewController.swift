//
//  ViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 17/12/24.
//

import UIKit
import SOTabBar

class ViewController: SOTabBarController, SOTabBarControllerDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardVCID")
        let budgetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BudgetListVCID")
        let transactionsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TransactionsVCID")
        let aiInsights = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVCID")
        
        homeVC.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(named: "DashboardTabItem"), selectedImage: UIImage(named: "DashboardTabItem"))
        budgetVC.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(named: "CategoryTabItem"), selectedImage: UIImage(named: "CategoryTabItem"))
        transactionsVC.tabBarItem = UITabBarItem(title: "Transactions", image: UIImage(named: "moneyChange"), selectedImage: UIImage(named: "moneyChange"))
        aiInsights.tabBarItem = UITabBarItem(title: "AiChatBot", image: UIImage(named: "AiChatBot"), selectedImage: UIImage(named: "AiChatBot"))
        self.delegate = self
        SOTabBarSetting.tabBarAnimationDurationTime = 0.1
        SOTabBarSetting.tabBarTintColor = UIColor.black
        SOTabBarSetting.tabBarHeight = 40
        SOTabBarSetting.tabBarSizeImage = 18
        
        viewControllers = [homeVC, budgetVC, transactionsVC, aiInsights]
    }
    func tabBarController(_ tabBarController: SOTabBarController, didSelect viewController: UIViewController) {
        print(viewController.tabBarItem.title ?? "")
    }
}


