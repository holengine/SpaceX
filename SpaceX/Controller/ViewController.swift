//
//  ViewController.swift
//  SpaceX
//
//  Created by Aleksandr Savinyh on 07.08.2022.
//

import UIKit
import Alamofire
import SwiftyTranslate

class ViewController: UIViewController {
    
    var items: Rockets = []
    var currentPage: Int = 0
    
    private let scrollView = UIScrollView()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRockets()
        scrollView.delegate = self
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        view.backgroundColor = .black
        view.addSubview(scrollView)
        view.addSubview(pageControl)
    }
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageControl.frame = CGRect(x: 10, y: view.frame.size.height-100, width: view.frame.size.width, height: 70)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-100)

        if scrollView.subviews.count == 2 {
            configureScrollView()
        }
    }
    
    private func configureScrollView() {
        scrollView.contentSize = CGSize(width: view.frame.size.width * 4, height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
    }

    private func updateLabel() {
        for x in 0..<items.count {
            let page = UIView(frame: CGRect(x: CGFloat(x) * view.frame.size.width, y: 0, width: view.frame.size.width, height: scrollView.frame.size.height))
            scrollView.addSubview(page)
            pageControl.numberOfPages = items.count
            
            let verticalScrollView = UIScrollView()
            verticalScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-100)
            verticalScrollView.contentSize = CGSize(width: view.frame.size.width, height: 1070)
            verticalScrollView.isPagingEnabled = true
            verticalScrollView.delegate = self
            verticalScrollView.showsVerticalScrollIndicator = false
            page.addSubview(verticalScrollView)
            
            let headColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
            let color = UIColor(red: 0.792, green: 0.792, blue: 0.792, alpha: 1)
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 315))
            imageView.imageFromUrl(urlString: items[x].flickrImages[0])
            verticalScrollView.addSubview(imageView)
            
            let corner = UIView(frame: CGRect(x: 0, y: 290, width: view.frame.size.width, height: 50))
            corner.backgroundColor = .black
            corner.layer.cornerRadius = 30
            corner.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            verticalScrollView.addSubview(corner)
            
            let nameLabel = UILabel(frame: CGRect(x: 32, y: 296, width: 200, height: 100))
            nameLabel.text = items[x].name
            nameLabel.textColor = headColor
            nameLabel.numberOfLines = 0
            nameLabel.font = UIFont(name: "LabGrotesque-Medium", size: 24)
            verticalScrollView.addSubview(nameLabel)

            
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 12
            layout.itemSize = CGSize(width: 89, height: 89)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
            layout.scrollDirection = .horizontal
            
            currentPage = x
           
            let collectionView = UICollectionView(frame: CGRect(x: 0, y: 386, width: view.frame.size.width, height: 89), collectionViewLayout: layout)
            collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = .black
            collectionView.showsHorizontalScrollIndicator = false
            verticalScrollView.addSubview(collectionView)
        
            let firstFlyLabel = UILabel(frame: CGRect(x: 32, y: 496, width: 200, height: 24))
            firstFlyLabel.text = "Первый запуск"
            firstFlyLabel.textColor = color
            firstFlyLabel.numberOfLines = 0
            firstFlyLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            verticalScrollView.addSubview(firstFlyLabel)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
            let dataDate = dateFormatter.date(from: items[x].firstFlight )!
            
            let firstFlyDataLabel = UILabel(frame: CGRect(x: view.frame.width - 232, y: 496, width: 200, height: 24))
            firstFlyDataLabel.text = dataDate.formatted(date: .long, time: .omitted)
            firstFlyDataLabel.textColor = headColor
            firstFlyDataLabel.textAlignment = .right
            firstFlyDataLabel.numberOfLines = 0
            firstFlyDataLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            verticalScrollView.addSubview(firstFlyDataLabel)
            
            let countryLabel = UILabel(frame: CGRect(x: 32, y: 536, width: 200, height: 24))
            countryLabel.text = "Страна"
            countryLabel.textColor = color
            countryLabel.numberOfLines = 0
            countryLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            verticalScrollView.addSubview(countryLabel)
            
            let dictCountry = ["United States":"США","Republic of the Marshall Islands":"Республика о. Маршалловы"]
            
            let countryDataLabel = UILabel(frame: CGRect(x: view.frame.width - 332, y: 536, width: 300, height: 24))
            countryDataLabel.text = dictCountry[items[x].country]
            countryDataLabel.textColor = headColor
            countryDataLabel.textAlignment = .right
            countryDataLabel.numberOfLines = 0
            countryDataLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            verticalScrollView.addSubview(countryDataLabel)
            
            let costLabel = UILabel(frame: CGRect(x: 32, y: 576, width: 200, height: 24))
            costLabel.text = "Стоимость запуска"
            costLabel.textColor = color
            costLabel.numberOfLines = 0
            costLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            verticalScrollView.addSubview(costLabel)
            
            let costDataLabel = UILabel(frame: CGRect(x: view.frame.width - 232, y: 576, width: 200, height: 24))
            costDataLabel.text = "$" + String(items[x].costPerLaunch / 1000000) + " млн"
            costDataLabel.textColor = headColor
            costDataLabel.textAlignment = .right
            costDataLabel.numberOfLines = 0
            costDataLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            verticalScrollView.addSubview(costDataLabel)
            
            //first step
            
            let fistStepGroupLabel = UILabel(frame: CGRect(x: 32, y: 640, width: 311, height: 24))
            fistStepGroupLabel.text = "ПЕРВАЯ СТУПЕНЬ"
            fistStepGroupLabel.textColor = headColor
            fistStepGroupLabel.numberOfLines = 0
            fistStepGroupLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            verticalScrollView.addSubview(fistStepGroupLabel)
            
            let amountEnginesFirstLabel = UILabel(frame: CGRect(x: 32, y: 680, width: 200, height: 24))
            amountEnginesFirstLabel.text = "Количество двигателей"
            amountEnginesFirstLabel.textColor = color
            amountEnginesFirstLabel.numberOfLines = 0
            amountEnginesFirstLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            verticalScrollView.addSubview(amountEnginesFirstLabel)
            
            let amountEnginesFirstDataLabel = UILabel(frame: CGRect(x: view.frame.width - 264, y: 680, width: 200, height: 24))
            amountEnginesFirstDataLabel.text = String(items[x].firstStage.engines)
            amountEnginesFirstDataLabel.textColor = headColor
            amountEnginesFirstDataLabel.textAlignment = .right
            amountEnginesFirstDataLabel.numberOfLines = 0
            amountEnginesFirstDataLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            verticalScrollView.addSubview(amountEnginesFirstDataLabel)
            
            let amountFuelFirstLabel = UILabel(frame: CGRect(x: 32, y: 720, width: 200, height: 24))
            amountFuelFirstLabel.text = "Количество топлива"
            amountFuelFirstLabel.textColor = color
            amountFuelFirstLabel.numberOfLines = 0
            amountFuelFirstLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            verticalScrollView.addSubview(amountFuelFirstLabel)
            
            let amountFuelFirstDataLabel = UILabel(frame: CGRect(x: view.frame.width - 264, y: 720, width: 200, height: 24))
            amountFuelFirstDataLabel.text = String(items[x].firstStage.fuelAmountTons)
            amountFuelFirstDataLabel.textColor = headColor
            amountFuelFirstDataLabel.textAlignment = .right
            amountFuelFirstDataLabel.textAlignment = .right
            amountFuelFirstDataLabel.numberOfLines = 0
            amountFuelFirstDataLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            verticalScrollView.addSubview(amountFuelFirstDataLabel)
            
            let tonLabel = UILabel(frame: CGRect(x: view.frame.width - 232, y: 720, width: 200, height: 24))
            tonLabel.text = "ton"
            tonLabel.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1)
            tonLabel.textAlignment = .right
            tonLabel.numberOfLines = 0
            tonLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            verticalScrollView.addSubview(tonLabel)
            
            
            let timeBurnFirstLabel = UILabel(frame: CGRect(x: 32, y: 760, width: 200, height: 24))
            timeBurnFirstLabel.text = "Время сгорания"
            timeBurnFirstLabel.textColor = color
            timeBurnFirstLabel.numberOfLines = 0
            timeBurnFirstLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            verticalScrollView.addSubview(timeBurnFirstLabel)
            
            let timeBurnFirstDataLabel = UILabel(frame: CGRect(x: view.frame.width - 264, y: 760, width: 200, height: 24))
            timeBurnFirstDataLabel.text = items[x].firstStage.burnTimeSEC?.formatted()
            timeBurnFirstDataLabel.textColor = headColor
            timeBurnFirstDataLabel.textAlignment = .right
            timeBurnFirstDataLabel.numberOfLines = 0
            timeBurnFirstDataLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            verticalScrollView.addSubview(timeBurnFirstDataLabel)
            
            let secLabel = UILabel(frame: CGRect(x: view.frame.width - 232, y: 760, width: 200, height: 24))
            secLabel.text = "sec"
            secLabel.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1)
            secLabel.textAlignment = .right
            secLabel.numberOfLines = 0
            secLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            verticalScrollView.addSubview(secLabel)
            
            //second step
            
            let secondStepGroupLabel = UILabel(frame: CGRect(x: 32, y: 824, width: 311, height: 24))
            secondStepGroupLabel.text = "ВТОРАЯ СТУПЕНЬ"
            secondStepGroupLabel.textColor = headColor
            secondStepGroupLabel.numberOfLines = 0
            secondStepGroupLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            verticalScrollView.addSubview(secondStepGroupLabel)
            
            let amountEnginesSecondLabel = UILabel(frame: CGRect(x: 32, y: 864, width: 200, height: 24))
            amountEnginesSecondLabel.text = "Количество двигателей"
            amountEnginesSecondLabel.textColor = color
            amountEnginesSecondLabel.numberOfLines = 0
            amountEnginesSecondLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            verticalScrollView.addSubview(amountEnginesSecondLabel)
            
            let amountEnginesSecondDataLabel = UILabel(frame: CGRect(x: view.frame.width - 264, y: 864, width: 200, height: 24))
            amountEnginesSecondDataLabel.text = String(items[x].secondStage.engines)
            amountEnginesSecondDataLabel.textColor = headColor
            amountEnginesSecondDataLabel.textAlignment = .right
            amountEnginesSecondDataLabel.numberOfLines = 0
            amountEnginesSecondDataLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            verticalScrollView.addSubview(amountEnginesSecondDataLabel)
            
            let amountFuelSecondLabel = UILabel(frame: CGRect(x: 32, y: 904, width: 200, height: 24))
            amountFuelSecondLabel.text = "Количество топлива"
            amountFuelSecondLabel.textColor = color
            amountFuelSecondLabel.numberOfLines = 0
            amountFuelSecondLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            verticalScrollView.addSubview(amountFuelSecondLabel)
            
            let amountFuelSecondDataLabel = UILabel(frame: CGRect(x: view.frame.width - 264, y: 904, width: 200, height: 24))
            amountFuelSecondDataLabel.text = String(items[x].secondStage.fuelAmountTons)
            amountFuelSecondDataLabel.textColor = headColor
            amountFuelSecondDataLabel.textAlignment = .right
            amountFuelSecondDataLabel.numberOfLines = 0
            amountFuelSecondDataLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            verticalScrollView.addSubview(amountFuelSecondDataLabel)
            
            let tonsLabel = UILabel(frame: CGRect(x: view.frame.width - 232, y: 904, width: 200, height: 24))
            tonsLabel.text = "ton"
            tonsLabel.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1)
            tonsLabel.textAlignment = .right
            tonsLabel.numberOfLines = 0
            tonsLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            verticalScrollView.addSubview(tonsLabel)
            
            
            let timeBurnSecondLabel = UILabel(frame: CGRect(x: 32, y: 944, width: 200, height: 24))
            timeBurnSecondLabel.text = "Время сгорания"
            timeBurnSecondLabel.textColor = color
            timeBurnSecondLabel.numberOfLines = 0
            timeBurnSecondLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            verticalScrollView.addSubview(timeBurnSecondLabel)
            
            let timeBurnSecondDataLabel = UILabel(frame: CGRect(x: view.frame.width - 264, y: 944, width: 200, height: 24))
            timeBurnSecondDataLabel.text = items[x].secondStage.burnTimeSEC?.formatted()
            timeBurnSecondDataLabel.textColor = headColor
            timeBurnSecondDataLabel.textAlignment = .right
            timeBurnSecondDataLabel.numberOfLines = 0
            timeBurnSecondDataLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            verticalScrollView.addSubview(timeBurnSecondDataLabel)
            
            let secsLabel = UILabel(frame: CGRect(x: view.frame.width - 232, y: 944, width: 200, height: 24))
            secsLabel.text = "sec"
            secsLabel.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1)
            secsLabel.textAlignment = .right
            secsLabel.numberOfLines = 0
            secsLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            verticalScrollView.addSubview(secsLabel)
            
            let buttonShowedLaunchs = UIButton(frame: CGRect(x: 56, y: 1008, width: 311, height: 56))
            buttonShowedLaunchs.setTitle("Показать запуски", for: .normal)
            buttonShowedLaunchs.setTitleColor(headColor, for: .normal)
            buttonShowedLaunchs.backgroundColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
            buttonShowedLaunchs.titleLabel?.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            buttonShowedLaunchs.layer.cornerRadius = 15
            verticalScrollView.addSubview(buttonShowedLaunchs)
        }
    }

    func fetchRockets() {
        let request =  AF.request("https://api.spacexdata.com/v4/rockets").validate()
        request.responseDecodable(of: Rockets.self) { response in
            guard let rockets = response.value else {return}
            self.items = rockets
            self.updateLabel()
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        
        cell.backgroundColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        cell.layer.cornerRadius = 30
        
        switch indexPath.row {
        case 0:
            cell.headLabel.text = String(items[0].height.meters ?? 0)
        case 1:
            cell.headLabel.text = String(items[0].diameter.meters ?? 0)
        case 2:
            cell.headLabel.text = String(items[0].mass.kg)
        case 3:
            cell.headLabel.text = String(items[0].payloadWeights[0].kg)
        default:
            cell.headLabel.text = ""
        }
  
        return cell
    }
}

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}

extension UIImageView {
  public func imageFromUrl(urlString: String) {
    if let url = URL(string: urlString) {
        let request = URLRequest(url: url)
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: .main, completionHandler: { (response, data, error) in
            if let imageData = data as NSData? {
                self.image = UIImage(data: imageData as Data)
            }
        })
    }
  }
}
