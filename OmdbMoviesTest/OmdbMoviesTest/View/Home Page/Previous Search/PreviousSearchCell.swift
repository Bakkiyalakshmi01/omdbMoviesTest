//
//  PreviousSearchCell.swift
//  OmdbMoviesTest
//
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

class PreviousSearchCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if UIDevice().isIPad {
            self.textLabel?.font = UIFont.appFontRoman(size: 22)
        } else {
            self.textLabel?.font = UIFont.appFontRoman(size: 17)
        }
    }
}
