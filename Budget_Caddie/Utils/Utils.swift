//
//  Utils.swift
//  Budget_Caddie
//
//  Created by Sabin on 18/12/24.
//

import Foundation
import UIKit
import PMAlertController
import SwiftMessages
import NVActivityIndicatorView
class Utils: NSObject {
    static let shared = Utils()
    var indecator: NVActivityIndicatorView?
    func checkNullvalue(passedValue:Any?) -> String {
        var param:Any?=passedValue
        if(param == nil || param is NSNull)
        {
            param=""
        } else {
            param = String(describing: passedValue!)
        }
        return (param as? String)!
    }
    func showCustomAlert(title: String, description: String, image: UIImage, vc: UIViewController) {
        let alertVC = PMAlertController(title: title, description: description, image: UIImage(named: "ResetPasswordImage"), style: .walkthrough)
        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
                    print("Capture action OK")
                }))
        vc.present(alertVC, animated: true, completion: nil)
    }
    @MainActor func swiftMessageAlert(theme: Theme, message: String, view: UIView, titleMessage: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(theme)
        view.configureDropShadow()
        view.configureContent(title: titleMessage, body: message)
        view.button?.isHidden = true
        view.layoutMarginAdditions = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 0
        SwiftMessages.show(view: view)
    }
    func convertDateFormat(from inputDate: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MMMM dd, yyyy"  // Input format
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures proper parsing

        guard let date = inputFormatter.date(from: inputDate) else {
            return nil // Return nil if the format is incorrect
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd-MM-yyyy" // Output format
        return outputFormatter.string(from: date)
    }
    func makeToast(message: String, vc: UIViewController) {
        vc.view.makeToast("", duration: 3.0, position: .bottom, title: message)
    }
    public func isValidPassword(passwordText: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: passwordText)
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func setupCornerRadius(for view: UIView,
                               cornerRadius: CGFloat = 10,
                               borderColor: UIColor = .lightGray,
                               borderWidth: CGFloat = 0.5,
                               shadowColor: UIColor = .black,
                               shadowOpacity: Float = 0.1,
                               shadowOffset: CGSize = CGSize(width: 0, height: 2),
                               shadowRadius: CGFloat = 4)  {
            // Apply corner radius
            view.layer.cornerRadius = cornerRadius
            view.layer.masksToBounds = false
            
            // Apply border
            view.layer.borderColor = borderColor.cgColor
            view.layer.borderWidth = borderWidth
            
            // Apply shadow
            view.layer.shadowColor = shadowColor.cgColor
            view.layer.shadowOpacity = shadowOpacity
            view.layer.shadowOffset = shadowOffset
            view.layer.shadowRadius = shadowRadius
        }
    func setupCornerRadiusAndGradient(for view: UIView,
                                      cornerRadius: CGFloat = 10,
                                      borderColor: UIColor = .lightGray,
                                      borderWidth: CGFloat = 0.5,
                                      shadowColor: UIColor = .black,
                                      shadowOpacity: Float = 0.1,
                                      shadowOffset: CGSize = CGSize(width: 0, height: 2),
                                      shadowRadius: CGFloat = 4,
                                      startColor: UIColor = .blue,
                                      endColor: UIColor = .purple,
                                      startPoint: CGPoint = CGPoint(x: 0, y: 0),
                                      endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        
        // Apply corner radius
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = false
        
        // Apply border
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = borderWidth

        // Apply shadow
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowOffset = shadowOffset
        view.layer.shadowRadius = shadowRadius

        // Remove any existing gradient layer to prevent duplicates
        if let existingGradient = view.layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
            existingGradient.removeFromSuperlayer()
        }

        // Create Gradient Layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = view.bounds
        gradientLayer.cornerRadius = cornerRadius
        
        // Insert the gradient below all other layers
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    func formatNormalDate(_ dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd MMMM yyyy" // Example: 26 March 2024
            return outputFormatter.string(from: date)
        }
        
        return nil // Return nil if parsing fails
    }
    func convertDateString(_ dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" // Input format
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = inputFormatter.date(from: dateString) else {
            return nil // Return nil if conversion fails
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd-MM-yyyy" // Desired format: "26 March 2024"

        return outputFormatter.string(from: date)
    }
    func startLoaderAnimation(vc: UIViewController) {
        DispatchQueue.main.async {
            self.indecator = NVActivityIndicatorView(frame: CGRect(x: vc.view.frame.midX - 20, y: vc.view.frame.midY - 20, width: 20, height: 20),type: .lineScalePulseOutRapid, color: .blue)
            vc.view.addSubview(self.indecator ?? UIView())
            self.indecator?.startAnimating()
        }
    }
    func stopLoadingAnimation() {
        DispatchQueue.main.async {
            self.indecator?.stopAnimating()
            self.indecator?.removeAllSubviews()
            self.indecator?.removeAllSubviews()
            self.indecator = nil
        }
        
    }
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   .random(in: 0...1),
            green: .random(in: 0...1),
            blue:  .random(in: 0...1),
           alpha: 1.0
        )
    }
}
extension UIView {
    func addDropShadow(color: UIColor = .black,
                       opacity: Float = 0.5,
                       offset: CGSize = CGSize(width: 0, height: 2),
                       radius: CGFloat = 4,
                       cornerRadius: CGFloat = 0) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
    }
    
}
extension Date {
    public func stringWithoutFormatChange() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    func formatDateToString() -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" // Example: "26 March 2024"
        return outputFormatter.string(from: self)
    }
}
extension Notification.Name {
    static let closeChatPageNotification = Notification.Name("closeChatPageNotificationIdentifier")
}
extension UIView {
    /// Remove all subview
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    /// Remove all subview with specific type
    func removeAllSubviews<T: UIView>(type: T.Type) {
        subviews
            .filter { $0 is T }
            .forEach { $0.removeFromSuperview() }
    }
}
