//
//  DraggableView.swift
//  Budget_Caddie
//
//  Created by Sabin on 05/03/25.
//

import Foundation
import UIKit

class FloatingView: UIView {
    
    private var initialCenter: CGPoint = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        self.layer.cornerRadius = 30
        self.clipsToBounds = true
        
        // Apply border
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        
        // Apply shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset =  CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        // Add Pan Gesture Recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let superview = self.superview else { return }
        
        let translation = gesture.translation(in: superview)
        
        switch gesture.state {
        case .began:
            initialCenter = self.center
        case .changed:
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            self.center = newCenter
        case .ended, .cancelled:
            // Ensure the view stays within screen bounds
            let safeFrame = superview.bounds.insetBy(dx: self.frame.width / 2, dy: self.frame.height / 2)
            let clampedX = min(max(self.center.x, safeFrame.minX), safeFrame.maxX)
            let clampedY = min(max(self.center.y, safeFrame.minY), safeFrame.maxY)
            UIView.animate(withDuration: 0.2) {
                self.center = CGPoint(x: clampedX, y: clampedY)
            }
        default:
            break
        }
    }
}
