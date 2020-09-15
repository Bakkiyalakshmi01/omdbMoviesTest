//
//  SearchViewController.swift
//  OmdbMoviesTest
//
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variable Declarations
    var searchActive : Bool = false
    var filtered: [String] = []
    var moviesList = ["Batman", "Spiderman", "Superman", "Ironman", "X-men", "Amazingman", "Life", "Love", "Twilight", "Narcos"]

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        let nibName = UINib(nibName: "SearchTableViewCell", bundle: nil)
        self.tableView?.register(nibName, forCellReuseIdentifier: "SearchTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        searchBar.delegate = self
        self.tableView.reloadData()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Search Movies"
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismissKeyboard()
    }
    
    // To dimiss the keyboard without triggering request
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismissKeyboard()
    }
    
    private func dismissKeyboard() {
        searchActive = false
        view.endEditing(true)
    }
    
}

extension SearchViewController : UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        self.dismissKeyboard()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.dismissKeyboard()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = moviesList.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if filtered.count == 0 {
            searchActive = false
        } else {
            searchActive = true
        }
        self.tableView.reloadData()
    }
}

extension SearchViewController : UITableViewDataSource, UITableViewDelegate {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        } else {
            if CacheManager.previousSearches.searches.count > 0 {
                return CacheManager.previousSearches.searches.count
            } else {
                return 0
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        if searchActive {
            cell.textLabel?.text = self.filtered[indexPath.row]
        } else {
            if CacheManager.previousSearches.searches.count > 0 {
                cell.textLabel?.text = CacheManager.previousSearches.searches[indexPath.row]
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchActive {
            if !CacheManager.previousSearches.searches.contains(self.filtered[indexPath.row]) {
                CacheManager.previousSearches.searches.append(self.filtered[indexPath.row])
            }
        }
        CacheManager.store(cache: .previousSearches)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: MovieViewController = (storyboard.instantiateViewController(withIdentifier: "movieVC") as? MovieViewController)!
        if searchActive {
            controller.movieName = self.filtered[indexPath.row]
        } else {
            controller.movieName = CacheManager.previousSearches.searches[indexPath.row]
        }
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchActive {
           return "Search Results"
        } else {
           return "Previous Searches"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.init(hex: "#F1F4F5")
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .darkGray
        header.textLabel?.font = UIFont.appFontBold(size: 20)
        header.textLabel?.minimumScaleFactor = 0.5
    }
}
