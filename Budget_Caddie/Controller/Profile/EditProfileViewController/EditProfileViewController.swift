//
//  EditProfileViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 30/12/24.
//

import UIKit
import CountryPickerView
import DropDown
class EditProfileViewController: UIViewController {

    @IBOutlet weak var currencyTxtFld: UITextField!
    @IBOutlet weak var countryTextFld: UITextField!
    @IBOutlet weak var userMobileTxtFld: UITextField!
    @IBOutlet weak var userEmailTxtFld: UITextField!
    @IBOutlet weak var userNameTxtFld: UITextField!
    let dropDown = DropDown()
    let cpv = CountryPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        cpv.frame = view.bounds
        cpv.dataSource = self
        cpv.delegate = self
        dropDown.dataSource = ["CAD", "USD", "GBP"]
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didClickBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didClickUpdateProfile(_ sender: UIButton) {
        
    }
    
    @IBAction func didClickUserCurrency(_ sender: UIButton) {
        dropDown.direction = .any
        dropDown.anchorView = self.currencyTxtFld
        dropDown.show()
        dropDown.selectionAction = { (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.currencyTxtFld.text = item
        }
    }
    @IBAction func didClickEditUserCountry(_ sender: UIButton) {
        cpv.showCountriesList(from: self)
    }
    
    @IBAction func didClickEditProfileImage(_ sender: UIButton) {
    }
}
extension EditProfileViewController: CountryPickerViewDataSource {
    
}
extension EditProfileViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print(country)
        self.countryTextFld.text = country.name
    }
    
}
