//
//  SearchTableViewCell.swift
//  GitHubAPI
//
//  Created by Bakkiya Lakshmi on 25/05/2020.
//  Copyright © 2020 Test. All rights reserved.
//


import UIKit
import Alamofire

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if UIDevice().isIPad {
            self.movieNameLabel.font = UIFont.appFontRoman(size: 22)
        } else {
            self.movieNameLabel.font = UIFont.appFontRoman(size: 17)
        }
    }
    
    func fetchImageFromURL(imageUrl: String) {
        AF.request( imageUrl, method: .get).response { response in
            switch response.result {
            case .success(let responseData):
            self.movieImageView.image = UIImage(data: responseData!, scale:1)?.resized(to: CGSize(width: 100, height: 80))
            case .failure(let error):
                print("error fetching image",error)
            }
        }
    }
}
