//
//  MovieViewController.swift
//  OmdbMoviesTest
//
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit
import Alamofire

class MovieViewController: UIViewController {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var releasedYear: UILabel!
    
    // MARK: - Variable Initializations
    var movieDetails : Movie!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupViewLabels()
        // Do any additional setup after loading the view.
        guard movieDetails.title != "" else {
            return
        }
        self.movieNameLabel.text = self.movieDetails.title
        self.fetchImageFromURL(imageUrl: self.movieDetails.poster)
        self.releasedYear.text = "Released year: \( self.movieDetails.year)"
        guard movieImageView.image != nil else {
            return
        }
    }
    
    func fetchImageFromURL(imageUrl: String) {
        AF.request( imageUrl, method: .get).response { response in
            switch response.result {
            case .success(let responseData):
                self.movieImageView.image = UIImage(data: responseData!, scale:1)?.resized(to: CGSize(width: 100.0, height: 100.0))
            case .failure(let error):
                print("error fetching image",error)
            }
        }
    }
    
    func setupViewLabels() {
        if UIDevice().isIPad {
            self.movieNameLabel.font = UIFont.appFontBold(size: 32)
            self.releasedYear.font = UIFont.appFontNormal(size: 26)
        } else {
            self.movieNameLabel.font = UIFont.appFontBold(size: 22)
            self.releasedYear.font = UIFont.appFontNormal(size: 17)
        }
    }
}
