//
//  RocketView.swift
//  SpaceX
//
//  Created by Aleksandr Savinyh on 18.08.2022.
//

import Foundation
import UIKit

class RocketCollectionViewFlowLayout: UICollectionViewFlowLayout {
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
        itemSize = CGSize(width: 89, height: 89)
        sectionInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
        scrollDirection = .horizontal
    }
}

class RocketCollectionView: UICollectionView {
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

class RegularGrayLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetting()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetting()
    }
    
    func initSetting() {
        textColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
        textAlignment = .left
        numberOfLines = 0
        font = UIFont(name: "LabGrotesque-Regular", size: 16)
    }
}

class RegularWhiteLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetting()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetting()
    }
    
    func initSetting() {
        textColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
        textAlignment = .right
        numberOfLines = 0
        font = UIFont(name: "LabGrotesque-Regular", size: 16)
    }
}

class BoldLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetting()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetting()
    }
    
    func initSetting() {
        textColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
        numberOfLines = 0
        font = UIFont(name: "LabGrotesque-Bold", size: 16)
    }
}

class MetricLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetting()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetting()
    }
    
    func initSetting() {
        textColor = UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1)
        textAlignment = .right
        numberOfLines = 0
        font = UIFont(name: "LabGrotesque-Bold", size: 16)
    }
}
