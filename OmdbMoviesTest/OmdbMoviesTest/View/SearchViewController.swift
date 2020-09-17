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
    @IBOutlet weak var searchTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - Variable Initializations
    var searchActive : Bool = false
    var filteredMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Search Movies"
        self.getSearchWordFromCache()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        if UIDevice().isIPad {
            self.searchLeadingConstraint.constant = 30
            self.searchTrailingConstraint.constant = 30
        } else {
            self.searchLeadingConstraint.constant = 10
            self.searchTrailingConstraint.constant = 50
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
    /// Gets the search word from PreviousSearches  cache
    private func getSearchWordFromCache() {
        let searchWord = CacheManager.previousSearches.selectedString
        guard searchWord != "" else {
          return
        }
        searchActive = true
        self.searchBar.text = searchWord
        self.fetchSearchedMovies(searchString: searchWord)
        CacheManager.previousSearches.selectedString = ""
        CacheManager.store(cache: .previousSearches)
    }
    
    /// Function to save the previous searches
    private func savePreviousSearch(_ searchText : String) {
        let str = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !CacheManager.previousSearches.searches.contains(str) else {
            return
        }
        CacheManager.previousSearches.searches.append(str)
        CacheManager.store(cache: .previousSearches)
    }
    
    /// Function to clear the search results data
    private func clearSearchData() {
        self.filteredMovies.removeAll()
        self.tableView.reloadData()
    }
    
    /// To dimiss the keyboard without triggering request
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismissKeyboard()
    }
    
    private func dismissKeyboard() {
        searchActive = false
        view.endEditing(true)
    }
}

extension SearchViewController : UISearchBarDelegate {
    //MARK:- Implementing search bar delegate methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        let searchText = searchBar.searchTextField.text
        guard searchText != "" else {
            return
        }
        self.savePreviousSearch(searchText!)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismissKeyboard()
        self.clearSearchData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dismissKeyboard()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.fetchSearchedMovies(searchString: searchText)
        if searchText.count <  1 {
            self.clearSearchData()
            searchActive = false
        } else {
            searchActive = true
        }
        self.tableView.reloadData()
    }
}

extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    //MARK:- Implementing table view delegate and datasource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            if filteredMovies.count > 0 {
                return filteredMovies.count
            }
            return 1
        } else {
            if CacheManager.previousSearches.searches.count > 0 {
                return CacheManager.previousSearches.searches.count
            }
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchActive {
            return 100
        }
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        if searchActive {
            if filteredMovies.count > 0 {
                let moviesList = self.filteredMovies[indexPath.row]
                cell.movieNameLabel?.text = moviesList.title
                cell.movieNameLabel.textAlignment = .left
                cell.fetchImageFromURL(imageUrl: moviesList.poster)
                cell.isUserInteractionEnabled = true
            } else {
                cell.movieImageView.image = nil
                cell.movieNameLabel.text = "No results found"
                cell.movieNameLabel.textAlignment = .left
                cell.isUserInteractionEnabled = false
            }
        } else {
            if CacheManager.previousSearches.searches.count > 0 {
                cell.movieImageView.image = nil
                cell.movieNameLabel.textAlignment = .left
                cell.movieNameLabel?.text = CacheManager.previousSearches.searches[indexPath.row]
                cell.isUserInteractionEnabled = true
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: MovieViewController = (storyboard.instantiateViewController(withIdentifier: "movieVC") as? MovieViewController)!
        if searchActive && self.filteredMovies.count > 0 {
            controller.movieDetails = self.filteredMovies[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: false)
        } else {
            searchActive = true
            self.searchBar.text = CacheManager.previousSearches.searches[indexPath.row]
            self.fetchSearchedMovies(searchString: CacheManager.previousSearches.searches[indexPath.row])
        }
    }
}

extension SearchViewController {
    //MARK:- Implementing table view header methods
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchActive {
           return "Search Results"
        } else {
           return "Previous Searches"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if UIDevice().isIPad {
            return 70
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.init(hex: "#F1F4F5")
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .darkGray
        if UIDevice().isIPad {
           header.textLabel?.font = UIFont.appFontBold(size: 26)
        } else {
           header.textLabel?.font = UIFont.appFontBold(size: 20)
        }
        header.textLabel?.minimumScaleFactor = 0.5
    }
}

extension SearchViewController {
   
    /// Get Request  to search movies api
    ///
    /// - Parameters:
    ///     - searchString: string value will be searched
    private func fetchSearchedMovies(searchString : String) {
        ServiceManager().fetchMovies(with: searchString) {
            (movieResp, error) in
            if movieResp != nil {
                self.filteredMovies.removeAll()
                for movies in movieResp!.search {
                    self.filteredMovies.append(movies)
                }
                self.tableView.reloadData()
            } else {
                print("Error json")
            }
        }
    }
}
