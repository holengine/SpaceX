//
//  ViewController.swift
//  SpaceX
//
//  Created by Aleksandr Savinyh on 07.08.2022.
//

import UIKit
import Alamofire

protocol SettingViewControllerDelegate: AnyObject {
    func updateAll(height: String, diameter: String, mass: String, payload: String)
}

class ViewController: UIViewController, SettingViewControllerDelegate {
    
    var items: Rockets = []
    
    var unitHeight = "m"
    var unitDiameter = "ft"
    var unitMass = "kg"
    var unitPayload = "kg"
    
    private let scrollView = UIScrollView()
    
    private let pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRockets()
        scrollView.delegate = self
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        view.backgroundColor = .black
        view.addSubview(scrollView)
        view.addSubview(pageControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideNavigationBar()
    }
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageControl.frame = CGRect(x: 10, y: view.frame.size.height-100, width: view.frame.size.width, height: 70)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.frame.size.height-100)
    }

    
    private func configureScrollView() {
        scrollView.contentSize = CGSize(width: Int(view.frame.size.width) * items.count, height: 1074)
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }

    private func updateLabel() {
        if scrollView.subviews.count >= 2 {
            configureScrollView()
        }
        
        for x in 0..<items.count {
            let page = UIView(frame: CGRect(x: CGFloat(x) * view.frame.size.width, y: 0, width: view.frame.size.width, height: scrollView.contentSize.height))
            scrollView.addSubview(page)
            pageControl.numberOfPages = items.count
            
            let headColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
            let color = UIColor(red: 0.792, green: 0.792, blue: 0.792, alpha: 1)
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 365))
            imageView.imageFromUrl(urlString: items[x].flickrImages[0])
            page.addSubview(imageView)
            
            let corner = UIView(frame: CGRect(x: 0, y: 288, width: view.frame.size.width, height: 80))
            corner.backgroundColor = .black
            corner.layer.cornerRadius = 30
            corner.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            page.addSubview(corner)
            
            let nameLabel = UILabel(frame: CGRect(x: 32, y: 296, width: 200, height: 100))
            nameLabel.text = items[x].name
            nameLabel.textColor = headColor
            nameLabel.numberOfLines = 0
            nameLabel.font = UIFont(name: "LabGrotesque-Medium", size: 24)
            page.addSubview(nameLabel)
            
            let settingButton = UIButton(frame: CGRect(x: view.frame.size.width-64, y: 326, width: 32, height: 32))
            settingButton.tintColor = .white
            settingButton.setBackgroundImage(UIImage(systemName: "gearshape"), for: .normal)
            settingButton.addTarget(self, action: #selector(showSettingMenu), for: .touchUpInside)
            page.addSubview(settingButton)

            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 12
            layout.itemSize = CGSize(width: 89, height: 89)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
            layout.scrollDirection = .horizontal
           
            let collectionView = UICollectionView(frame: CGRect(x: 0, y: 386, width: view.frame.size.width, height: 89), collectionViewLayout: layout)
            collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = .black
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.tag = x
            page.addSubview(collectionView)
        
            let firstFlyLabel = UILabel(frame: CGRect(x: 32, y: 496, width: 200, height: 24))
            firstFlyLabel.text = "Первый запуск"
            firstFlyLabel.textColor = color
            firstFlyLabel.numberOfLines = 0
            firstFlyLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            page.addSubview(firstFlyLabel)
            
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
            page.addSubview(firstFlyDataLabel)
            
            let countryLabel = UILabel(frame: CGRect(x: 32, y: 536, width: 200, height: 24))
            countryLabel.text = "Страна"
            countryLabel.textColor = color
            countryLabel.numberOfLines = 0
            countryLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            page.addSubview(countryLabel)
            
            let dictCountry = ["United States":"США","Republic of the Marshall Islands":"Республика о. Маршалловы"]
            
            let countryDataLabel = UILabel(frame: CGRect(x: view.frame.width - 332, y: 536, width: 300, height: 24))
            countryDataLabel.text = dictCountry[items[x].country]
            countryDataLabel.textColor = headColor
            countryDataLabel.textAlignment = .right
            countryDataLabel.numberOfLines = 0
            countryDataLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            page.addSubview(countryDataLabel)
            
            let costLabel = UILabel(frame: CGRect(x: 32, y: 576, width: 200, height: 24))
            costLabel.text = "Стоимость запуска"
            costLabel.textColor = color
            costLabel.numberOfLines = 0
            costLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            page.addSubview(costLabel)
            
            let costDataLabel = UILabel(frame: CGRect(x: view.frame.width - 232, y: 576, width: 200, height: 24))
            costDataLabel.text = "$" + String(items[x].costPerLaunch / 1000000) + " млн"
            costDataLabel.textColor = headColor
            costDataLabel.textAlignment = .right
            costDataLabel.numberOfLines = 0
            costDataLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            page.addSubview(costDataLabel)
            
            //first step
            
            let fistStepGroupLabel = UILabel(frame: CGRect(x: 32, y: 640, width: 311, height: 24))
            fistStepGroupLabel.text = "ПЕРВАЯ СТУПЕНЬ"
            fistStepGroupLabel.textColor = headColor
            fistStepGroupLabel.numberOfLines = 0
            fistStepGroupLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            page.addSubview(fistStepGroupLabel)
            
            let amountEnginesFirstLabel = UILabel(frame: CGRect(x: 32, y: 680, width: 200, height: 24))
            amountEnginesFirstLabel.text = "Количество двигателей"
            amountEnginesFirstLabel.textColor = color
            amountEnginesFirstLabel.numberOfLines = 0
            amountEnginesFirstLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            page.addSubview(amountEnginesFirstLabel)
            
            let amountEnginesFirstDataLabel = UILabel(frame: CGRect(x: view.frame.width - 264, y: 680, width: 200, height: 24))
            amountEnginesFirstDataLabel.text = String(items[x].firstStage.engines)
            amountEnginesFirstDataLabel.textColor = headColor
            amountEnginesFirstDataLabel.textAlignment = .right
            amountEnginesFirstDataLabel.numberOfLines = 0
            amountEnginesFirstDataLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            page.addSubview(amountEnginesFirstDataLabel)
            
            let amountFuelFirstLabel = UILabel(frame: CGRect(x: 32, y: 720, width: 200, height: 24))
            amountFuelFirstLabel.text = "Количество топлива"
            amountFuelFirstLabel.textColor = color
            amountFuelFirstLabel.numberOfLines = 0
            amountFuelFirstLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            page.addSubview(amountFuelFirstLabel)
            
            let amountFuelFirstDataLabel = UILabel(frame: CGRect(x: view.frame.width - 264, y: 720, width: 200, height: 24))
            amountFuelFirstDataLabel.text = String(items[x].firstStage.fuelAmountTons)
            amountFuelFirstDataLabel.textColor = headColor
            amountFuelFirstDataLabel.textAlignment = .right
            amountFuelFirstDataLabel.textAlignment = .right
            amountFuelFirstDataLabel.numberOfLines = 0
            amountFuelFirstDataLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            page.addSubview(amountFuelFirstDataLabel)
            
            let tonLabel = UILabel(frame: CGRect(x: view.frame.width - 232, y: 720, width: 200, height: 24))
            tonLabel.text = "ton"
            tonLabel.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1)
            tonLabel.textAlignment = .right
            tonLabel.numberOfLines = 0
            tonLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            page.addSubview(tonLabel)
            
            let timeBurnFirstLabel = UILabel(frame: CGRect(x: 32, y: 760, width: 200, height: 24))
            timeBurnFirstLabel.text = "Время сгорания"
            timeBurnFirstLabel.textColor = color
            timeBurnFirstLabel.numberOfLines = 0
            timeBurnFirstLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            page.addSubview(timeBurnFirstLabel)
            
            let timeBurnFirstDataLabel = UILabel(frame: CGRect(x: view.frame.width - 264, y: 760, width: 200, height: 24))
            timeBurnFirstDataLabel.text = items[x].firstStage.burnTimeSEC?.formatted()
            timeBurnFirstDataLabel.textColor = headColor
            timeBurnFirstDataLabel.textAlignment = .right
            timeBurnFirstDataLabel.numberOfLines = 0
            timeBurnFirstDataLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            page.addSubview(timeBurnFirstDataLabel)
            
            let secLabel = UILabel(frame: CGRect(x: view.frame.width - 232, y: 760, width: 200, height: 24))
            secLabel.text = "sec"
            secLabel.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1)
            secLabel.textAlignment = .right
            secLabel.numberOfLines = 0
            secLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            page.addSubview(secLabel)
            
            //second step
            
            let secondStepGroupLabel = UILabel(frame: CGRect(x: 32, y: 824, width: 311, height: 24))
            secondStepGroupLabel.text = "ВТОРАЯ СТУПЕНЬ"
            secondStepGroupLabel.textColor = headColor
            secondStepGroupLabel.numberOfLines = 0
            secondStepGroupLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            page.addSubview(secondStepGroupLabel)
            
            let amountEnginesSecondLabel = UILabel(frame: CGRect(x: 32, y: 864, width: 200, height: 24))
            amountEnginesSecondLabel.text = "Количество двигателей"
            amountEnginesSecondLabel.textColor = color
            amountEnginesSecondLabel.numberOfLines = 0
            amountEnginesSecondLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            page.addSubview(amountEnginesSecondLabel)
            
            let amountEnginesSecondDataLabel = UILabel(frame: CGRect(x: view.frame.width - 264, y: 864, width: 200, height: 24))
            amountEnginesSecondDataLabel.text = String(items[x].secondStage.engines)
            amountEnginesSecondDataLabel.textColor = headColor
            amountEnginesSecondDataLabel.textAlignment = .right
            amountEnginesSecondDataLabel.numberOfLines = 0
            amountEnginesSecondDataLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            page.addSubview(amountEnginesSecondDataLabel)
            
            let amountFuelSecondLabel = UILabel(frame: CGRect(x: 32, y: 904, width: 200, height: 24))
            amountFuelSecondLabel.text = "Количество топлива"
            amountFuelSecondLabel.textColor = color
            amountFuelSecondLabel.numberOfLines = 0
            amountFuelSecondLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            page.addSubview(amountFuelSecondLabel)
            
            let amountFuelSecondDataLabel = UILabel(frame: CGRect(x: view.frame.width - 264, y: 904, width: 200, height: 24))
            amountFuelSecondDataLabel.text = String(items[x].secondStage.fuelAmountTons)
            amountFuelSecondDataLabel.textColor = headColor
            amountFuelSecondDataLabel.textAlignment = .right
            amountFuelSecondDataLabel.numberOfLines = 0
            amountFuelSecondDataLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            page.addSubview(amountFuelSecondDataLabel)
            
            let tonsLabel = UILabel(frame: CGRect(x: view.frame.width - 232, y: 904, width: 200, height: 24))
            tonsLabel.text = "ton"
            tonsLabel.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1)
            tonsLabel.textAlignment = .right
            tonsLabel.numberOfLines = 0
            tonsLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            page.addSubview(tonsLabel)
            
            
            let timeBurnSecondLabel = UILabel(frame: CGRect(x: 32, y: 944, width: 200, height: 24))
            timeBurnSecondLabel.text = "Время сгорания"
            timeBurnSecondLabel.textColor = color
            timeBurnSecondLabel.numberOfLines = 0
            timeBurnSecondLabel.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            page.addSubview(timeBurnSecondLabel)
            
            let timeBurnSecondDataLabel = UILabel(frame: CGRect(x: view.frame.width - 264, y: 944, width: 200, height: 24))
            timeBurnSecondDataLabel.text = items[x].secondStage.burnTimeSEC?.formatted()
            timeBurnSecondDataLabel.textColor = headColor
            timeBurnSecondDataLabel.textAlignment = .right
            timeBurnSecondDataLabel.numberOfLines = 0
            timeBurnSecondDataLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            page.addSubview(timeBurnSecondDataLabel)
            
            let secsLabel = UILabel(frame: CGRect(x: view.frame.width - 232, y: 944, width: 200, height: 24))
            secsLabel.text = "sec"
            secsLabel.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.561, alpha: 1)
            secsLabel.textAlignment = .right
            secsLabel.numberOfLines = 0
            secsLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            page.addSubview(secsLabel)
            
            let buttonShowedLaunchs = UIButton(frame: CGRect(x: 56, y: 1008, width: 311, height: 56))
            buttonShowedLaunchs.setTitle("Показать запуски", for: .normal)
            buttonShowedLaunchs.setTitleColor(headColor, for: .normal)
            buttonShowedLaunchs.backgroundColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
            buttonShowedLaunchs.titleLabel?.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            buttonShowedLaunchs.layer.cornerRadius = 15
            buttonShowedLaunchs.addTarget(self, action: #selector(showLaunchs), for: .touchUpInside)
            buttonShowedLaunchs.tag = x
            page.addSubview(buttonShowedLaunchs)
        }
    }
    
    @objc private func showSettingMenu() {
        let secondController = SettingViewController()
        secondController.unitHeight = unitHeight
        secondController.unitDiameter = unitDiameter
        secondController.unitMass = unitMass
        secondController.unitPayload = unitPayload
        secondController.delegate = self
        present(secondController, animated: true)
    }

    @objc private func showLaunchs(sender: UIButton) {
        let secondController = SecondViewController()
        secondController.rocketName = items[sender.tag].name
        secondController.rocketID = items[sender.tag].id
        navigationController?.pushViewController(secondController, animated: true)
    }

    func fetchRockets() {
        let request =  AF.request("https://api.spacexdata.com/v4/rockets").validate()
        request.responseDecodable(of: Rockets.self) { response in
            guard let rockets = response.value else {return}
            self.items = rockets
            self.updateLabel()
        }
    }
    
    func updateAll(height: String, diameter: String, mass: String, payload: String) {
        unitHeight = height
        unitDiameter = diameter
        unitMass = mass
        unitPayload = payload
        print("fdsfsdf")
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int((floorf(Float(scrollView.contentOffset.x) / Float(view.frame.size.width))))
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
            if unitHeight == "m" {
                cell.headLabel.text = String(items[collectionView.tag].height.meters ?? 0)
            }else {
                cell.headLabel.text = String(items[collectionView.tag].height.feet ?? 0)
            }
            cell.secondLabel.text = "Высота, " + unitHeight
        case 1:
            if unitDiameter == "m" {
                cell.headLabel.text = String(items[collectionView.tag].diameter.meters ?? 0)
            }else {
                cell.headLabel.text = String(items[collectionView.tag].diameter.feet ?? 0)
            }
            cell.secondLabel.text = "Диаметр, " + unitDiameter
        case 2:
            if unitMass == "kg" {
                cell.headLabel.text = String(items[collectionView.tag].mass.kg)
            }else {
                cell.headLabel.text = String(items[collectionView.tag].mass.lb)
            }
            cell.secondLabel.text = "Масса, " + unitMass
        case 3:
            if unitPayload == "kg" {
                cell.headLabel.text = String(items[collectionView.tag].payloadWeights[0].kg)
            }else {
                cell.headLabel.text = String(items[collectionView.tag].payloadWeights[0].lb)
            }
            cell.secondLabel.text = "Нагрузка, " + unitPayload
        default:
            break
        }
        collectionView.reloadData()
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

extension UIViewController {
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}


