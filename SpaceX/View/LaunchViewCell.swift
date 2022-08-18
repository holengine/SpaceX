//
//  LaunchCell.swift
//  SpaceX
//
//  Created by Aleksandr Savinyh on 14.08.2022.
//

import Foundation
import UIKit

class LaunchViewCell: UICollectionViewCell {
    
    static let identifier = "LaunchCell"

    var nameLabel: UILabel = {
        var nameLabel = UILabel()
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 1
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont(name: "LabGrotesque-Medium", size: 20)
        return nameLabel
    }()
    
    var dataLabel: UILabel = {
        var dataLabel = UILabel()
        dataLabel.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1)
        dataLabel.textAlignment = .left
        dataLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
        return dataLabel
    }()
    
    var statusLaunchImage = UIImageView()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        layer.cornerRadius = 30
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(dataLabel)
        contentView.addSubview(statusLaunchImage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 24, y: contentView.center.y-25, width: contentView.frame.size.width-100, height: 32)
        dataLabel.frame = CGRect(x: 24, y: contentView.center.y, width: 300, height: 32)
        statusLaunchImage.frame = CGRect(x: contentView.frame.size.width-64, y: contentView.center.y-15, width: 32, height: 32)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

