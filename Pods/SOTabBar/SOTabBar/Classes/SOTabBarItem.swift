//
//  SOTabBarItem.swift
//  SOTabBar
//
//  Created by ahmad alsofi on 1/3/20.
//  Copyright © 2020 ahmad alsofi. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class SOTabBarItem: UIView {
    
    let image: UIImage
    let title: String
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = self.title
        lbl.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        lbl.textColor = UIColor.darkGray
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var tabImageView: UIImageView = {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(tabBarItem item: UITabBarItem) {
        guard let selecteImage = item.image else {
            fatalError("You should set image to all view controllers")
        }
        self.image = selecteImage
        self.title = item.title ?? ""
        super.init(frame: .zero)
        drawConstraints()
    }
    
    private func drawConstraints() {
        self.addSubview(titleLabel)
        self.addSubview(tabImageView)
        NSLayoutConstraint.activate([
            tabImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            tabImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            tabImageView.heightAnchor.constraint(equalToConstant: SOTabBarSetting.tabBarSizeImage),
            tabImageView.widthAnchor.constraint(equalToConstant: SOTabBarSetting.tabBarSizeImage),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: SOTabBarSetting.tabBarHeight),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   internal func animateTabSelected() {
        tabImageView.alpha = 1
        titleLabel.alpha = 0
        UIView.animate(withDuration: SOTabBarSetting.tabBarAnimationDurationTime) { [weak self] in
            self?.changeTitleLabelToOriginal(titleLabel: self?.titleLabel)
            self?.titleLabel.alpha = 1
            self?.titleLabel.frame.origin.y = SOTabBarSetting.tabBarHeight / 1.8
            self?.tabImageView.frame.origin.y = -5
            self?.tabImageView.alpha = 0
        }
    }
    
    internal func animateTabDeSelect() {
        tabImageView.alpha = 1
        UIView.animate(withDuration: SOTabBarSetting.tabBarAnimationDurationTime) { [weak self] in
            self?.changeTitleLabelDesign(titleLabel: self?.titleLabel)
            self?.titleLabel.frame.origin.y = SOTabBarSetting.tabBarHeight / 1.5
            self?.tabImageView.frame.origin.y = (SOTabBarSetting.tabBarHeight / 2) - CGFloat(SOTabBarSetting.tabBarSizeImage / 2)
            self?.tabImageView.alpha = 1
            self?.titleLabel.alpha = 0.5
        }
    }
    internal func changeTitleLabelDesign(titleLabel: UILabel?) {
        
        titleLabel?.text = self.title
        titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        titleLabel?.textColor = UIColor.black
        titleLabel?.textAlignment = .center
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
    }
    internal func changeTitleLabelToOriginal(titleLabel: UILabel?) {
        titleLabel?.text = self.title
        titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        titleLabel?.textColor = UIColor.darkGray
        titleLabel?.textAlignment = .center
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
    }
}
