//
//  CustomView.swift
//  GoGreen
//
//  Created by MAC-OBS-26 on 04/10/20.
//  Copyright © 2020 MAC-OBS-26. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
class CustomView: UIView {
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
    @IBInspectable override var backgroundColor: UIColor?{
        set{
            guard let uiColor = newValue else{return}
            layer.backgroundColor = uiColor.cgColor
        }
        
        get {
            guard let color = layer.backgroundColor else{return nil}
            return UIColor(cgColor: color)
        }
        
    }
}

extension UIView {
    func edgesToSuperview(_ padding: CGFloat) {
        paddingToSuperView(left: padding, top: padding, right: padding, bottom: padding)
    }
    
    func topLeftToSuperview(_ padding: CGFloat, size: CGFloat) {
        paddingToSuperView(left: padding, top: padding, width: size, height: size)
    }
    
    func bottomRightToSuperview(_ padding: CGFloat, size: CGFloat) {
        paddingToSuperView(right: padding, bottom: padding, width: size, height: size)
    }
    
    /// 添加内边距
    private func paddingToSuperView(left: CGFloat? = nil,
                                    top: CGFloat? = nil,
                                    right: CGFloat? = nil,
                                    bottom: CGFloat? = nil,
                                    width: CGFloat? = nil,
                                    height: CGFloat? = nil) {
        
        // 开启约束布局
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let ops = NSLayoutConstraint.FormatOptions.alignAllLeft
        let views = ["view": self]
        
        if (left != nil) || (right != nil) {
            var hVfl = "H:"
            
            if left != nil {
                hVfl += "|-\(left!)-"
            }
            
            hVfl += "[view"
            
            if width != nil {
                hVfl += "(\(width!))"
            }
            
            hVfl += "]"
            
            if right != nil {
                hVfl += "-\(right!)-|"
            }
            
            let hConsts = NSLayoutConstraint.constraints(withVisualFormat: hVfl, options: ops, metrics: nil, views: views)
            self.superview?.addConstraints(hConsts)
        }
        
        if (top != nil) || (bottom != nil) {
            var vVfl = "V:"
            
            if top != nil {
                vVfl += "|-\(top!)-"
            }
            
            vVfl += "[view"
            
            if height != nil {
                vVfl += "(\(height!))"
            }
            
            vVfl += "]"
            
            if bottom != nil {
                vVfl += "-\(bottom!)-|"
            }
            
            let vConsts = NSLayoutConstraint.constraints(withVisualFormat: vVfl, options: ops, metrics: nil, views: views)
            self.superview?.addConstraints(vConsts)
        }
    }
}

class CircleView : UIView {
 
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
             layer.cornerRadius = newValue / 2
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
    

}
