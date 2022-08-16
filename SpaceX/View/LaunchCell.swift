//
//  LaunchCell.swift
//  SpaceX
//
//  Created by Aleksandr Savinyh on 14.08.2022.
//

import Foundation
import UIKit

class LaunchCell: UICollectionViewCell {
    
    static let identifier = "LaunchCell"

    var headLabel: UILabel = {
        var headLabel = UILabel()
        headLabel.textColor = .white
        headLabel.textAlignment = .left
        headLabel.font = UIFont(name: "LabGrotesque-Medium", size: 20)
        return headLabel
    }()
    
    var secondLabel: UILabel = {
        var secondLabel = UILabel()
        secondLabel.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1)
        secondLabel.textAlignment = .left
        secondLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
        return secondLabel
    }()
    
    var statusLaunchImage = UIImageView()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(headLabel)
        contentView.addSubview(secondLabel)
        contentView.addSubview(statusLaunchImage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headLabel.frame = CGRect(x: 24, y: -5, width: 300, height: 80)
        secondLabel.frame = CGRect(x: 24, y: 20, width: 300, height: 80)
        statusLaunchImage.frame = CGRect(x: contentView.frame.size.width-64, y: contentView.center.y-15, width: 32, height: 32)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

