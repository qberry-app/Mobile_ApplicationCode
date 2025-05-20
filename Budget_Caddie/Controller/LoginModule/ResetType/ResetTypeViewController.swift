//
//  ResetTypeViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 18/12/24.
//

import UIKit

class ResetTypeViewController: UIViewController {
    var userEmail: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetViaEmailButton(_ sender: UIButton) {
        if let resetViaEmail: ForgetPassword_EmailViewController = storyboard?.instantiateViewController(withIdentifier: "ForgetPassword_EmailVCID") as? ForgetPassword_EmailViewController {
            resetViaEmail.email = userEmail
            resetViaEmail.modalPresentationStyle = .fullScreen
            self.present(resetViaEmail, animated: true)
        }
    }
    
    @IBAction func resetViaPhone(_ sender: UIButton) {
        if let resetViaPhoneVc: ForgetPassword_MobileViewController = storyboard?.instantiateViewController(withIdentifier: "ForgetPassword_MobileVCID") as? ForgetPassword_MobileViewController {
            resetViaPhoneVc.userEmail = userEmail
            resetViaPhoneVc.modalPresentationStyle = .fullScreen
            self.present(resetViaPhoneVc, animated: true)
        }
    }
    @IBAction func didClickDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVc =  segue.destination as? ForgetPassword_MobileViewController
        destinationVc?.userEmail = userEmail
    }

}
