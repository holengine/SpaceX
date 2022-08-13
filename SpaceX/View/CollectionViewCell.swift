//
//  CollectionViewCell.swift
//  SpaceX
//
//  Created by Aleksandr Savinyh on 13.08.2022.
//

import Foundation
import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomCollectionViewCell"

    var headLabel: UILabel = {
        var headLabel = UILabel()
        headLabel.textColor = .white
        headLabel.textAlignment = .center
        headLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
        return headLabel
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(headLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headLabel.frame = CGRect(x: 0, y: 0, width: 89, height: 89)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

