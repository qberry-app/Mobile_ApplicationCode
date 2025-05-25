//
//  SelectDefaultCategoriesViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 17/04/25.
//

import UIKit

class SelectDefaultCategoriesViewController: UIViewController {

    @IBOutlet weak var defaultCategorycollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func didClickBackButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    

}
