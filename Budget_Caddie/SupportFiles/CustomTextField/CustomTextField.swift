//
//  CustomTextField.swift
//  Budget_Caddie
//
//  Created by Sabin on 29/12/24.
//

import Foundation


import UIKit

@IBDesignable
class CustomTextField: UITextField {

    @IBInspectable var placeholderColor: UIColor? {
        didSet {
            updatePlaceholderColor()
        }
    }
    
    private func updatePlaceholderColor() {
        guard let placeholderText = placeholder, let placeholderColor = placeholderColor else {
            return
        }
        
        attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [.foregroundColor: placeholderColor]
        )
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updatePlaceholderColor()
    }
}
