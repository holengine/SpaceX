//
//  SecondViewController.swift
//  SpaceX
//
//  Created by Aleksandr Savinyh on 14.08.2022.
//

import Foundation
import UIKit

class LaunchViewController: UIViewController, LaunchDataDelegate {
    
    private let dataSource = LaunchData()
    
    var launches: Launches = [] {
        didSet {
            for launch in launches {
                if (launch.rocket.rawValue == rocketID) {
                    goodLaunches.append(launch)
                }
            }
            collectionView.reloadData()
        }
    }
    
    var goodLaunches: Launches = []
    
    var rocketID: String = ""
    var rocketName: String = ""

    let collectionView: LaunchCollectionView = {
        let layout: LaunchCollectionViewFlowLayout = LaunchCollectionViewFlowLayout()
        
        let collectionView = LaunchCollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showNavigationBar()
        dataSource.requestData()
    }
    
    private func configureView() {
        view.backgroundColor = .black
        
        self.navigationItem.title = rocketName
        self.navigationController?.navigationBar.tintColor = .white
        
        dataSource.delegate = self
        
        collectionView.register(LaunchViewCell.self, forCellWithReuseIdentifier: LaunchViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
    }
    
    func didRecieveDataUpdate(data: Launches) {
        launches = data
    }
    
    private func dateFormated(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        let dataDate = dateFormatter.date(from: date)
        
        return dataDate ?? nil
    }
}

extension LaunchViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodLaunches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = configureLaunchCell(collectionView: collectionView, indexPath: indexPath)
        
        return cell
    }
}

extension LaunchViewController {
    func configureLaunchCell(collectionView: UICollectionView, indexPath: IndexPath) -> LaunchViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LaunchViewCell.identifier, for: indexPath) as! LaunchViewCell
        
        cell.nameLabel.text = goodLaunches[indexPath.item].name
        cell.dataLabel.text = dateFormated(date: goodLaunches[indexPath.item].dateUTC)?.formatted(date: .long, time: .omitted)
        
        switch goodLaunches[indexPath.item].success {
            case .none:
                cell.statusLaunchImage.image = UIImage(named: "failure")
            case .some(_):
                cell.statusLaunchImage.image = UIImage(named: "success")
        }
        
        return cell
    }
}
