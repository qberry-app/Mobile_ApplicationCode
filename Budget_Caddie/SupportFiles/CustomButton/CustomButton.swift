//
//  CustomButton.swift
//  Pixly
//
//  Created by MAC-OBS-26 on 01/10/20.
//  Copyright © 2020 MAC-OBS-27. All rights reserved.
//
import UIKit
import Foundation

@IBDesignable
class CustomButton: UIButton {
     @IBInspectable var borderWidth: CGFloat {
           set {
               layer.borderWidth = newValue
           }
           get {
               return layer.borderWidth
           }
       }

       @IBInspectable var cornerRadius: CGFloat {
           set {
               layer.cornerRadius = newValue
           }
           get {
               return layer.cornerRadius
           }
       }

       @IBInspectable var borderColor: UIColor? {
           set {
               guard let uiColor = newValue else { return }
               layer.borderColor = uiColor.cgColor
           }
           get {
               guard let color = layer.borderColor else { return nil }
               return UIColor(cgColor: color)
           }
       }
    @IBInspectable public var referenceText: String = "" {
              didSet {
                  self.setTitle(NSLocalizedString(referenceText, comment: ""), for: .normal)
              }
          }
}
