//
//  LaunchView.swift
//  SpaceX
//
//  Created by Aleksandr Savinyh on 18.08.2022.
//

import Foundation
import UIKit

class LaunchCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        initSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSetting() {
        minimumInteritemSpacing = 0
        minimumLineSpacing = 12
        itemSize = CGSize(width: UIScreen.main.bounds.width-64, height: UIScreen.main.bounds.height/10)
        sectionInset = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
        scrollDirection = .vertical
    }
}

class LaunchCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSetting() {
        backgroundColor = .black
        showsHorizontalScrollIndicator = false
    }
}
