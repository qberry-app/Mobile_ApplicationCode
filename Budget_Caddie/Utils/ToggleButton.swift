//
//  ToggleButton.swift
//  Budget_Caddie
//
//  Created by Sabin on 17/01/25.
//

import Foundation

import UIKit

@IBDesignable
class StylishToggleButton: UIControl {
    
    @IBInspectable var isOn: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    @IBInspectable var onColor: UIColor = UIColor.systemGreen
    @IBInspectable var offColor: UIColor = UIColor.lightGray
    @IBInspectable var sliderColor: UIColor = UIColor.white
    
    private let backgroundView = UIView()
    private let sliderView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        // Background view
        backgroundView.layer.cornerRadius = frame.height / 2
        backgroundView.isUserInteractionEnabled = false
        addSubview(backgroundView)
        
        // Slider view
        sliderView.layer.cornerRadius = (frame.height - 4) / 2
        sliderView.backgroundColor = sliderColor
        sliderView.isUserInteractionEnabled = false
        addSubview(sliderView)
        
        // Initial appearance
        updateAppearance()
        
        // Add tap gesture
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleState)))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.frame = bounds
        sliderView.frame = CGRect(
            x: isOn ? bounds.width - bounds.height + 2 : 2,
            y: 2,
            width: bounds.height - 4,
            height: bounds.height - 4
        )
    }
    
    private func updateAppearance() {
        backgroundView.backgroundColor = isOn ? onColor : offColor
        sliderView.backgroundColor = sliderColor
        
        UIView.animate(withDuration: 0.3) {
            self.sliderView.frame = CGRect(
                x: self.isOn ? self.bounds.width - self.bounds.height + 2 : 2,
                y: 2,
                width: self.bounds.height - 4,
                height: self.bounds.height - 4
            )
        }
    }
    
    @objc private func toggleState() {
        isOn.toggle()
        sendActions(for: .valueChanged)
        updateAppearance()
    }
}
