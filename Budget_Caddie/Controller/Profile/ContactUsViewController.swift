//
//  ContactUsViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 24/12/24.
//

import UIKit

class ContactUsViewController: UIViewController {

    @IBOutlet weak var messageTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var nameTextFld: UITextField!
    @IBOutlet weak var mainContentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.shared.setupCornerRadius(for: mainContentView, borderWidth: 0.2)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didClickSendMessageButton(_ sender: UIButton) {
        print("Message Send Successfully")
    }
    @IBAction func didClickBackButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
