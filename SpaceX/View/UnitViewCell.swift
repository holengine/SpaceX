//
//  CollectionViewCell.swift
//  SpaceX
//
//  Created by Aleksandr Savinyh on 13.08.2022.
//

import Foundation
import UIKit

class UnitViewCell: UICollectionViewCell {
    
    static let identifier = "UnitViewCell"

    var headLabel: UILabel = {
        var headLabel = UILabel()
        headLabel.textColor = .white
        headLabel.textAlignment = .center
        headLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
        return headLabel
    }()
    
    var secondLabel: UILabel = {
        var secondLabel = UILabel()
        secondLabel.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1)
        secondLabel.textAlignment = .center
        secondLabel.font = UIFont(name: "LabGrotesque-Regular", size: 13)
        return secondLabel
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        layer.cornerRadius = 30
        contentView.addSubview(headLabel)
        contentView.addSubview(secondLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headLabel.frame = CGRect(x: 0, y: -10, width: 89, height: 89)
        secondLabel.frame = CGRect(x: 0, y: 13, width: 89, height: 89)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

