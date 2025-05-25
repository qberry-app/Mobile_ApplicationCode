//
//  HowItWorksViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 31/01/25.
//

import UIKit
import Alamofire

class HowItWorksViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didClickNextButton(_ sender: UIButton) {
        print("Next Button clicked")
//
        let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChooseSubscriptionVCID") as! ChooseSubscriptionViewController
                profileViewController.modalPresentationStyle = .fullScreen
                self.present(profileViewController, animated: true)
    }
    
    

}
