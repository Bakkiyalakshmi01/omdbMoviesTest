//
//  Theme.swift
//  OmdbMoviesTest
//
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

extension UIColor {
    class var appThemeColor: UIColor {
        return UIColor(hex: "008545")!
    }
    
    class var appThemeColorDarker: UIColor {
        return UIColor(hex: "005E31")!
    }
    
    class var appThemeColorButtonBG: UIColor {
        return UIColor(hex: "f3f6f6")!
    }
    
    class var appThemeColorTextButton: UIColor {
        return UIColor(hex: "868383")!
    }
    
    class var appThemeColorDarkGrayTextButton: UIColor {
        return UIColor(hex: "898686")!
    }
}


extension UIFont {
    class func appFontNormal(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
    
    class func appFontBold(size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    class func appFontRoman(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
}


extension UIScrollView {
    var currentPage: Int {
        return Int((self.contentOffset.x + (0.5*self.frame.size.width))/self.frame.width)+1
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            self.contentInset = .zero;
            self.scrollIndicatorInsets = .zero;
            self.contentOffset = CGPoint.init(x: 0.0, y: 0.0)
        }
    }
}
