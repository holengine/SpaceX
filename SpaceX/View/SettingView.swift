//
//  SettingView.swift
//  SpaceX
//
//  Created by Aleksandr Savinyh on 18.08.2022.
//

import Foundation
import UIKit

class SettingLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetting()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetting()
    }
    
    func initSetting() {
        textAlignment = .left
        font = UIFont(name: "LabGrotesque-Regular", size: 16)
        textColor = .white
    }
}

class SettingSegmentControl: UISegmentedControl {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetting()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        initSetting()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetting()
    }
    
    func initSetting() {
        layer.cornerRadius = 5.0
        backgroundColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        tintColor = UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1)
        selectedSegmentTintColor = .white
        setTitleColor(UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1))
        setTitleColorSelected(.black)
    }
}

extension SettingSegmentControl {
    func setTitleColor(_ color: UIColor, state: UIControl.State = .normal) {
        var attributes = self.titleTextAttributes(for: state) ?? [:]
        attributes[.foregroundColor] = color
        self.setTitleTextAttributes(attributes, for: state)
    }
    
    func setTitleColorSelected(_ color: UIColor, state: UIControl.State = .selected) {
        var attributes = self.titleTextAttributes(for: state) ?? [:]
        attributes[.foregroundColor] = color
        self.setTitleTextAttributes(attributes, for: state)
    }
}
