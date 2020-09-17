//
//  HomeViewController.swift
//  OmdbMoviesTest
//
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Variable Initializations
    var popularMovies : [Movie] = []
    var storedOffsetPopular = [Int: CGFloat]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "OMDB Movies"
        self.fetchPopularMovies()
    }

    private func setView() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        
        if UIDevice().isIPad {
            self.tableViewLeadingConstraint.constant = 20
            self.tableViewTrailingConstraint.constant = 20
        } else {
            self.tableViewLeadingConstraint.constant = 10
            self.tableViewTrailingConstraint.constant = 10
        }
        // Register nib files
        let nibName = UINib(nibName: "PreviousSearchCell", bundle: nil)
        self.tableView?.register(nibName, forCellReuseIdentifier: "PreviousSearchCell")
        
        let nibName2 = UINib(nibName: "PopularMoviesCell", bundle: nil)
        self.tableView?.register(nibName2, forCellReuseIdentifier: "PopularMoviesCell")
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    //MARK:- Implementing table view delegate and datasource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        if CacheManager.previousSearches.searches.count > 0 {
            return 2
        }
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 &&  CacheManager.previousSearches.searches.count > 0  {
            return CacheManager.previousSearches.searches.count
        } else if section == 0 {
            return 1
        }
        return 0
     }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 1 && CacheManager.previousSearches.searches.count > 0  {
              return 60
        } else if indexPath.section == 0 {
            if UIDevice().isIPad {
                return 400
            }
            return 200
        }
        return 0
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 &&  CacheManager.previousSearches.searches.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousSearchCell", for:indexPath) as! PreviousSearchCell
            cell.textLabel?.text =  CacheManager.previousSearches.searches[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopularMoviesCell", for: indexPath) as! PopularMoviesCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            CacheManager.previousSearches.selectedString = CacheManager.previousSearches.searches[indexPath.row]
            CacheManager.store(cache: .previousSearches)
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       if section == 1 {
            return "Previous Searches"
        } else {
            return "Popular Movies"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if UIDevice().isIPad {
            return 100
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.init(hex: "#F1F4F5")
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .darkGray
        header.textLabel?.minimumScaleFactor = 0.5
        if UIDevice().isIPad {
           header.textLabel?.font = UIFont.appFontBold(size: 26)
        } else {
           header.textLabel?.font = UIFont.appFontBold(size: 20)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? PopularMoviesCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsetPopular[indexPath.row] ?? 0
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? PopularMoviesCell else { return }
        storedOffsetPopular[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK:- Implementing collection view delegate and datasource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.popularMovies.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCollectionCell", for: indexPath)  as! PopularCollectionCell
            //TODO:
        cell.fetchImageFromURL(imageUrl: self.popularMovies[indexPath.row].poster)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: MovieViewController = (storyboard.instantiateViewController(withIdentifier: "movieVC") as? MovieViewController)!
        controller.movieDetails = self.popularMovies[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        UIDevice().getItemSize()
    }
}

extension HomeViewController {
   
    // Get Request api call to display popular movies in 2020
    ///
    /// parameters :   string , year - Man as random search string and year as 2020
    private func fetchPopularMovies() {
        self.popularMovies.removeAll()
        ServiceManager().fetchMovies(with: "Man&y=2020") {
            (movieResp, error) in
            if movieResp != nil {
                for movies in movieResp!.search {
                    self.popularMovies.append(movies)
                }
                self.tableView.reloadData()
            } else {
                print("Error json")
            }
        }
    }
}
