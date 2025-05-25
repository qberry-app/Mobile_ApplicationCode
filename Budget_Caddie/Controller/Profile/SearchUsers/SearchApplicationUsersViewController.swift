//
//  SearchApplicationUsersViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 19/01/25.
//

import UIKit

class SearchApplicationUsersViewController: UIViewController {

    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var noResultFoundView: UIView!
    var searchResultCount: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        userSearchBar.tintColor = UIColor.black
        registerTableCell()
        // Do any additional setup after loading the view.
    }
    func registerTableCell() {
        self.searchResultTableView.register(UINib(nibName: "MyFriendsListTableViewCell",
                                               bundle: nil), forCellReuseIdentifier: "MyFriendsListTableViewCell")
        self.searchResultTableView.rowHeight = 111.0
        self.searchResultTableView.estimatedRowHeight = 111.0
        self.searchResultTableView.delegate = self
        self.searchResultTableView.separatorStyle = .none
        self.searchResultTableView.dataSource = self
        self.searchResultTableView.reloadData()
    }
}
extension SearchApplicationUsersViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: false)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            searchResultCount = 0
            noResultFoundView.isHidden = false
            searchResultTableView.isHidden = true
            
        } else {
            searchResultCount = searchText.count
            noResultFoundView.isHidden = true
            searchResultTableView.isHidden = false
            searchResultTableView.reloadData()
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            searchResultCount = 0
            noResultFoundView.isHidden = false
            searchResultTableView.isHidden = true
        } else {
            searchResultCount = searchBar.text?.count ?? 4
            noResultFoundView.isHidden = true
            searchResultTableView.isHidden = false
            searchResultTableView.reloadData()
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            searchResultCount = 0
            noResultFoundView.isHidden = false
            searchResultTableView.isHidden = true
        } else {
            searchResultCount = searchBar.text?.count ?? 4
            noResultFoundView.isHidden = true
            searchResultTableView.isHidden = false
            searchResultTableView.reloadData()
        }
    }
}
extension SearchApplicationUsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = searchResultTableView.dequeueReusableCell(withIdentifier: "MyFriendsListTableViewCell") as? MyFriendsListTableViewCell {
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}
extension SearchApplicationUsersViewController: UITableViewDelegate {
    
}
