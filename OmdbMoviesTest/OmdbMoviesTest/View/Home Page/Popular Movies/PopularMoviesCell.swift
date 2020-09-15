//
//  PopularMoviesCell.swift
//  OmdbMoviesTest
//
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

class PopularMoviesCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var viewHeight : CGFloat = 0.0

    override func awakeFromNib() {
        super.awakeFromNib()
    // Initialization code
        let nibName = UINib(nibName: "PopularCollectionCell", bundle: nil)
        self.collectionView?.register(nibName, forCellWithReuseIdentifier: "PopularCollectionCell")
        self.collectionView!.contentInset = UIEdgeInsets(top: -10, left: 10, bottom:10, right: 10)
    }
    
    func getItemSize() -> CGSize {
        var sizeArea = CGSize()
        let itemHeight = self.collectionView.frame.size.height
        let frameSize = self.collectionView.frame.size
        if (UIScreen.main.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            if frameSize.width < self.viewHeight {
                print("It's Portrait iPad")
                let spacing = frameSize.width
                let itemWidth = spacing / 2
                sizeArea = CGSize(width: itemWidth, height: itemHeight)
            } else {
                print("It's Landscape iPad")
                let spacing = frameSize.width
                let itemWidth = spacing / 3
                let itemHeight = itemWidth
                sizeArea = CGSize(width: itemWidth, height: itemHeight)
            }
        } else if (UIScreen.main.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone) {
            if frameSize.width < self.viewHeight {
                print("It's Portrait iPhone")
                sizeArea = CGSize(width: frameSize.width, height: itemHeight)
            } else {
                print("It's Landscape iPhone")
                let spacing = frameSize.width - 20
                let itemWidth = spacing / 3
                sizeArea = CGSize(width: itemWidth, height: itemHeight)
            }
        } else if (UIScreen.main.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.tv) {
          
        } else if (UIScreen.main.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.unspecified) {
            print("It's Unspecified Device")
            if frameSize.width < self.viewHeight {
                print("It's Portrait iPhone")
                
                sizeArea = CGSize(width: frameSize.width, height: itemHeight)
            } else {
                print("It's Landscape iPhone")
                let spacing = frameSize.width - 20
                let itemWidth = spacing / 3
                sizeArea = CGSize(width: itemWidth, height: itemHeight)
            }
        }
        return sizeArea
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        self.collectionView!.contentInset = UIEdgeInsets(top: -10, left: 10, bottom:10, right: 10)
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 15
            layout.minimumLineSpacing = 15
            layout.itemSize = self.getItemSize()
            layout.invalidateLayout()
        }

    }
    
}

extension PopularMoviesCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {

        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
    }

    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
}
