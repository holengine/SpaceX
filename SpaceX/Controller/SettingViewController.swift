//
//  SettingViewController.swift
//  SpaceX
//
//  Created by Aleksandr Savinyh on 15.08.2022.
//

import Foundation
import UIKit

class SettingViewController: UIViewController {
    
    let unitsSize = ["m", "ft"]
    let unitsMass = ["kg", "lb"]
    
    var unitHeight = "m"
    var unitDiameter = "m"
    var unitMass = "kg"
    var unitPayload = "kg"
    
    var delegate: SettingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1)
        self.navigationItem.title = "Настройки"
        self.navigationItem.titleView?.tintColor = .white
        presentationController?.delegate = self
        setValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showNavigationBar()
    }
    
    func setValues() {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        title.textAlignment = .center
        title.text = "Настройки"
        title.font = UIFont(name: "LabGrotesque-Regular", size: 16)
        title.textColor = .white
        view.addSubview(title)
        
        let buttonBack = UIButton(frame: CGRect(x: view.frame.size.width-102, y: 0, width: 70, height: 50))
        buttonBack.setTitle("Закрыть", for: .normal)
        buttonBack.titleLabel?.textAlignment = .left
        buttonBack.titleLabel?.font = UIFont(name: "LabGrotesque-Bold", size: 16)
        buttonBack.setTitleColor(.white, for: .normal)
        buttonBack.addTarget(self, action: #selector(actionBack), for: .touchUpInside)
        view.addSubview(buttonBack)
        
        let heightLabel = UILabel(frame: CGRect(x: 32, y: 120, width: 150, height: 50))
        heightLabel.textAlignment = .left
        heightLabel.text = "Высота"
        heightLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
        heightLabel.textColor = .white
        view.addSubview(heightLabel)
        
        let diameterLabel = UILabel(frame: CGRect(x: 32, y: 180, width: 150, height: 50))
        diameterLabel.textAlignment = .left
        diameterLabel.text = "Диаметр"
        diameterLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
        diameterLabel.textColor = .white
        view.addSubview(diameterLabel)
        
        let massLabel = UILabel(frame: CGRect(x: 32, y: 240, width: 150, height: 50))
        massLabel.textAlignment = .left
        massLabel.text = "Масса"
        massLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
        massLabel.textColor = .white
        view.addSubview(massLabel)
        
        let payloadLabel = UILabel(frame: CGRect(x: 32, y: 300, width: 150, height: 50))
        payloadLabel.textAlignment = .left
        payloadLabel.text = "Полезная нагрузка"
        payloadLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
        payloadLabel.textColor = .white
        view.addSubview(payloadLabel)
        
        let heightSegment = UISegmentedControl(items: unitsSize)
        heightSegment.selectedSegmentIndex = unitsSize.firstIndex(of: unitHeight) ?? 0
        heightSegment.frame = CGRect(x: view.frame.size.width-147, y: 120, width: 115, height: 40)
        heightSegment.layer.cornerRadius = 5.0
        heightSegment.backgroundColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        heightSegment.tintColor = UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1)
        heightSegment.selectedSegmentTintColor = .white
        heightSegment.addTarget(self, action: #selector(changeColor), for: .valueChanged)
        heightSegment.tag = 1
        heightSegment.setTitleColor(UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1))
        heightSegment.setTitleColorSelected(.black)
        view.addSubview(heightSegment)
        
        let diameterSegment = UISegmentedControl(items: unitsSize)
        diameterSegment.selectedSegmentIndex = unitsSize.firstIndex(of: unitDiameter) ?? 0
        diameterSegment.frame = CGRect(x: view.frame.size.width-147, y: 180, width: 115, height: 40)
        diameterSegment.layer.cornerRadius = 5.0
        diameterSegment.backgroundColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        diameterSegment.tintColor = UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1)
        diameterSegment.selectedSegmentTintColor = .white
        diameterSegment.addTarget(self, action: #selector(changeColor), for: .valueChanged)
        diameterSegment.tag = 2
        diameterSegment.setTitleColor(UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1))
        diameterSegment.setTitleColorSelected(.black)
        view.addSubview(diameterSegment)
        
        let massSegment = UISegmentedControl(items: unitsMass)
        massSegment.selectedSegmentIndex = unitsMass.firstIndex(of: unitMass) ?? 0
        massSegment.frame = CGRect(x: view.frame.size.width-147, y: 240, width: 115, height: 40)
        massSegment.layer.cornerRadius = 5.0
        massSegment.backgroundColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        massSegment.tintColor = UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1)
        massSegment.selectedSegmentTintColor = .white
        massSegment.addTarget(self, action: #selector(changeColor), for: .valueChanged)
        massSegment.tag = 3
        massSegment.setTitleColor(UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1))
        massSegment.setTitleColorSelected(.black)
        view.addSubview(massSegment)
        
        let payloadSegment = UISegmentedControl(items: unitsMass)
        payloadSegment.selectedSegmentIndex = unitsMass.firstIndex(of: unitPayload) ?? 0
        payloadSegment.frame = CGRect(x: view.frame.size.width-147, y: 300, width: 115, height: 40)
        payloadSegment.layer.cornerRadius = 5.0
        payloadSegment.backgroundColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        payloadSegment.tintColor = UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1)
        payloadSegment.selectedSegmentTintColor = .white
        payloadSegment.addTarget(self, action: #selector(changeColor), for: .valueChanged)
        payloadSegment.tag = 4
        payloadSegment.setTitleColor(UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1))
        payloadSegment.setTitleColorSelected(.black)
        view.addSubview(payloadSegment)
    }
    
    @objc func changeColor(sender: UISegmentedControl) {
        switch sender.tag {
        case 1:
            unitHeight = unitsSize[sender.selectedSegmentIndex]
        case 2:
            unitDiameter = unitsSize[sender.selectedSegmentIndex]
        case 3:
            unitMass = unitsMass[sender.selectedSegmentIndex]
        case 4:
            unitPayload = unitsMass[sender.selectedSegmentIndex]
        default:
            break
        }
    }
    
    @objc func actionBack() {
        self.delegate?.updateAll(height: unitHeight, diameter: unitDiameter, mass: unitMass, payload: unitPayload)
        dismiss(animated: true)
    }
}

extension UISegmentedControl {
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

extension SettingViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.delegate?.updateAll(height: unitHeight, diameter: unitDiameter, mass: unitMass, payload: unitPayload)
    }
}
