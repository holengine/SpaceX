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
    
    var unitHeight = ""
    var unitDiameter = ""
    var unitMass = ""
    var unitPayload = ""
    
    var delegate: SettingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showNavigationBar()
    }
    
    private func configureView() {
        view.backgroundColor = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1)
        
        self.navigationItem.title = "Настройки"
        self.navigationItem.titleView?.tintColor = .white
        
        presentationController?.delegate = self
        
        let title: UILabel = {
            let title = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
            title.textAlignment = .center
            title.text = "Настройки"
            title.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            title.textColor = .white
            return title
        }()
        view.addSubview(title)
        
        let buttonBack: UIButton = {
            let buttonBack = UIButton(frame: CGRect(x: view.frame.size.width-102, y: 0, width: 70, height: 50))
            buttonBack.setTitle("Закрыть", for: .normal)
            buttonBack.titleLabel?.textAlignment = .left
            buttonBack.titleLabel?.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            buttonBack.setTitleColor(.white, for: .normal)
            buttonBack.addTarget(self, action: #selector(actionBack), for: .touchUpInside)
            return buttonBack
        }()
        view.addSubview(buttonBack)
        
        let heightLabel: SettingLabel = {
            let heightLabel = SettingLabel(frame: CGRect(x: 32, y: 120, width: 150, height: 50))
            heightLabel.text = "Высота"
            return heightLabel
        }()
        view.addSubview(heightLabel)
        
        let diameterLabel: SettingLabel = {
            let diameterLabel = SettingLabel(frame: CGRect(x: 32, y: 180, width: 150, height: 50))
            diameterLabel.text = "Диаметр"
            return diameterLabel
        }()
        view.addSubview(diameterLabel)
        
        let massLabel: SettingLabel = {
            let massLabel = SettingLabel(frame: CGRect(x: 32, y: 240, width: 150, height: 50))
            massLabel.text = "Масса"
            return massLabel
        }()
        view.addSubview(massLabel)
        
        let payloadLabel: SettingLabel = {
            let payloadLabel = SettingLabel(frame: CGRect(x: 32, y: 300, width: 150, height: 50))
            payloadLabel.text = "Полезная нагрузка"
            return payloadLabel
        }()
        view.addSubview(payloadLabel)
        
        let heightSegment: SettingSegmentControl = {
            let heightSegment = SettingSegmentControl(items: unitsSize)
            heightSegment.frame = CGRect(x: view.frame.size.width-147, y: 120, width: 115, height: 40)
            heightSegment.selectedSegmentIndex = unitsSize.firstIndex(of: unitHeight) ?? 0
            heightSegment.tag = 1
            heightSegment.addTarget(self, action: #selector(changeUnits), for: .valueChanged)
            return heightSegment
        }()
        view.addSubview(heightSegment)
        
        let diameterSegment: SettingSegmentControl = {
            let diameterSegment = SettingSegmentControl(items: unitsSize)
            diameterSegment.frame = CGRect(x: view.frame.size.width-147, y: 180, width: 115, height: 40)
            diameterSegment.selectedSegmentIndex = unitsSize.firstIndex(of: unitDiameter) ?? 0
            diameterSegment.tag = 2
            diameterSegment.addTarget(self, action: #selector(changeUnits), for: .valueChanged)
            return diameterSegment
        }()
        view.addSubview(diameterSegment)

        let massSegment: SettingSegmentControl = {
            let massSegment = SettingSegmentControl(items: unitsMass)
            massSegment.frame = CGRect(x: view.frame.size.width-147, y: 240, width: 115, height: 40)
            massSegment.selectedSegmentIndex = unitsMass.firstIndex(of: unitMass) ?? 0
            massSegment.tag = 3
            massSegment.addTarget(self, action: #selector(changeUnits), for: .valueChanged)
            return massSegment
        }()
        view.addSubview(massSegment)
        
        let payloadSegment: SettingSegmentControl = {
            let payloadSegment = SettingSegmentControl(items: unitsMass)
            payloadSegment.frame = CGRect(x: view.frame.size.width-147, y: 300, width: 115, height: 40)
            payloadSegment.selectedSegmentIndex = unitsMass.firstIndex(of: unitPayload) ?? 0
            payloadSegment.tag = 4
            payloadSegment.addTarget(self, action: #selector(changeUnits), for: .valueChanged)
            return payloadSegment
        }()
        view.addSubview(payloadSegment)
    }
    
    @objc func changeUnits(sender: UISegmentedControl) {
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
        self.delegate?.updateUnits(height: unitHeight, diameter: unitDiameter, mass: unitMass, payload: unitPayload)
        dismiss(animated: true)
    }
}

extension SettingViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.delegate?.updateUnits(height: unitHeight, diameter: unitDiameter, mass: unitMass, payload: unitPayload)
    }
}
