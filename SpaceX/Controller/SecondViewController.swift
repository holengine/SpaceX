//
//  SecondViewController.swift
//  SpaceX
//
//  Created by Aleksandr Savinyh on 14.08.2022.
//

import Foundation
import UIKit
import Alamofire

class SecondViewController: UIViewController {
    
    var items: Launches = []
    var goodLaunches: Launches = []
    var rocketID: String = ""
    var rocketName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLaucnhes()
        view.backgroundColor = .black
        self.navigationItem.title = rocketName
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showNavigationBar()
    }
    
    func fetchLaucnhes() {
        let request =  AF.request("https://api.spacexdata.com/v4/launches").validate()
        request.responseDecodable(of: Launches.self) { response in
            guard let launches = response.value else {return}
            self.items = launches
            self.parseLaunch()
            self.updateLabel()
        }
    }
    
    func parseLaunch() {
        for launch in items {
            if (launch.rocket.rawValue == rocketID) {
                goodLaunches.append(launch)
            }
        }
    }
    
    private func updateLabel() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: view.frame.size.width-64, height: view.frame.size.height/10)
        layout.sectionInset = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
       
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), collectionViewLayout: layout)
        collectionView.register(LaunchCell.self, forCellWithReuseIdentifier: LaunchCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)
    }
    
    func dateFormated(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        let dataDate = dateFormatter.date(from: date)
        
        return dataDate ?? nil
    }
}

extension SecondViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodLaunches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LaunchCell.identifier, for: indexPath) as! LaunchCell
        
        cell.backgroundColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        cell.layer.cornerRadius = 30
        
        cell.headLabel.text = goodLaunches[indexPath.item].name
        cell.secondLabel.text = dateFormated(date: goodLaunches[indexPath.item].dateUTC)?.formatted(date: .long, time: .omitted)
        return cell
    }
}
