//
//  PopularMoviesCell.swift
//  OmdbMoviesTest
//
//  Copyright © 2020 Test. All rights reserved.
//

import UIKit

class PopularMoviesCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
    // Initialization code
        let nibName = UINib(nibName: "PopularCollectionCell", bundle: nil)
        self.collectionView?.register(nibName, forCellWithReuseIdentifier: "PopularCollectionCell")
       
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        self.collectionView.showsHorizontalScrollIndicator = false

        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
          layout.minimumInteritemSpacing = 20
          layout.minimumLineSpacing = 10
          layout.itemSize = getItemSize()
          layout.invalidateLayout()
        }
    }
    
    func getItemSize() -> CGSize {
        var sizeArea = CGSize()
        let itemHeight = self.collectionView.frame.size.height-10
        let frameSize = self.frame.size
        if  UIDevice().isIPad {
            if UIDevice().isDevicePortrait {
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
        } else if UIDevice().isIPhone {
            if UIDevice().isDevicePortrait {
                sizeArea = CGSize(width: self.frame.size.width-40, height: self.collectionView.frame.size.height-10)
            } else {
                let spacing = frameSize.width - 20
                let itemWidth = spacing / 2
                sizeArea = CGSize(width: itemWidth, height: itemHeight)
            }
        } else if (UIScreen.main.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.tv) {
          
        } else if (UIScreen.main.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.unspecified) {
            print("It's Unspecified Device")
            if UIDevice().isDevicePortrait {
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
        self.collectionView!.contentInset = UIEdgeInsets(top: -15, left: 10, bottom:0, right: 10)
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
            layout.itemSize = getItemSize()
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
