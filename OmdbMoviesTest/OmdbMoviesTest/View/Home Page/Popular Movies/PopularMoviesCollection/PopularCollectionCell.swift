//
//  PopularCollectionCell.swift
//  OmdbMoviesTest
//
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit
import Alamofire

class PopularCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fetchImageFromURL(imageUrl: String) {
        AF.request( imageUrl, method: .get).response { response in
            switch response.result {
            case .success(let responseData):
                self.imageView.image = UIImage(data: responseData!, scale:1)?.resized(to: UIDevice().getItemSize())
                self.imageView.contentMode = .center
            case .failure(let error):
                print("error fetching image",error)
            }
        }
    }
}
