//
//  ViewController.swift
//  SpaceX
//
//  Created by Aleksandr Savinyh on 07.08.2022.
//

import UIKit

protocol SettingViewControllerDelegate: AnyObject {
    func updateUnits(height: String, diameter: String, mass: String, payload: String)
}

class RocketViewController: UIViewController {
    
    private let dataSource = RocketData()
    
    var rockets: Rockets = [] {
        didSet {
            configureView()
        }
    }
    
    var unitHeight = "m"
    var unitDiameter = "ft"
    var unitMass = "kg"
    var unitPayload = "kg"
    
    private let scrollView = UIScrollView()
    
    private let pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        dataSource.delegate = self
        
        dataSource.requestData()
        
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        
        
        view.addSubview(pageControl)
        view.addSubview(scrollView)
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
        pageControl.frame = CGRect(x: 0, y: view.frame.size.height-70, width: view.frame.size.width, height: 70)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-70)
    }
    
    private func dateFormated(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        let dataDate = dateFormatter.date(from: date)
        return dataDate ?? nil
    }

    private func configureView() {
        view.backgroundColor = .black
        
        scrollView.contentSize = CGSize(width: Int(view.frame.size.width) * rockets.count, height: Int(view.frame.size.height)-70)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        pageControl.numberOfPages = rockets.count
        
        for index in 0..<rockets.count {
            let page = UIView(frame: CGRect(x: CGFloat(index) * view.frame.size.width, y: 0, width: view.frame.size.width, height: scrollView.contentSize.height))
            configurePage(page: page, index: index)
            scrollView.addSubview(page)
        }
    }
    
    private func configurePage(page: UIView, index: Int) {
        let verticalScrollView = UIScrollView()
        verticalScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-100)
        verticalScrollView.contentSize = CGSize(width: view.frame.size.width, height: 1074)
        verticalScrollView.showsVerticalScrollIndicator = false
        page.addSubview(verticalScrollView)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: -50, width: view.frame.size.width, height: 370))
        imageView.imageFromUrl(urlString: rockets[index].flickrImages[0])
        imageView.layer.cornerRadius = 1200
        verticalScrollView.addSubview(imageView)
        
        let lowerCorner = UIView(frame: CGRect(x: 0, y: 288, width: view.frame.size.width, height: 80))
        lowerCorner.backgroundColor = .black
        lowerCorner.layer.cornerRadius = 30
        lowerCorner.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        verticalScrollView.addSubview(lowerCorner)
        
        let nameLabel = UILabel(frame: CGRect(x: 32, y: 296, width: 200, height: 100))
        nameLabel.text = rockets[index].name
        nameLabel.textColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont(name: "LabGrotesque-Medium", size: 24)
        verticalScrollView.addSubview(nameLabel)
        
        let settingButton = UIButton(frame: CGRect(x: view.frame.size.width-64, y: 326, width: 32, height: 32))
        settingButton.tintColor = .white
        settingButton.setBackgroundImage(UIImage(systemName: "gearshape"), for: .normal)
        settingButton.addTarget(self, action: #selector(showSettingMenu), for: .touchUpInside)
        verticalScrollView.addSubview(settingButton)

        let layout: RocketCollectionViewFlowLayout = RocketCollectionViewFlowLayout()
       
        let collectionView = RocketCollectionView(frame: CGRect(x: 0, y: 386, width: view.frame.size.width, height: 89), collectionViewLayout: layout)
        collectionView.register(UnitViewCell.self, forCellWithReuseIdentifier: UnitViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = index
        
        verticalScrollView.addSubview(collectionView)
    
        let firstFlyLabel = RegularGrayLabel(frame: CGRect(x: 32, y: 496, width: 200, height: 24))
        firstFlyLabel.text = "Первый запуск"
        verticalScrollView.addSubview(firstFlyLabel)
        
        let firstFlyDataLabel = RegularWhiteLabel(frame: CGRect(x: view.frame.width - 232, y: 496, width: 200, height: 24))
        firstFlyDataLabel.text = dateFormated(date: rockets[index].firstFlight)?.formatted(date: .long, time: .omitted)
        verticalScrollView.addSubview(firstFlyDataLabel)
        
        let countryLabel = RegularGrayLabel(frame: CGRect(x: 32, y: 536, width: 200, height: 24))
        countryLabel.text = "Страна"
        verticalScrollView.addSubview(countryLabel)
        
        let dictCountry = ["United States":"США","Republic of the Marshall Islands":"Республика о. Маршалловы"]

        let countryDataLabel = RegularWhiteLabel(frame: CGRect(x: view.frame.width - 332, y: 536, width: 300, height: 24))
        countryDataLabel.text = dictCountry[rockets[index].country]
        verticalScrollView.addSubview(countryDataLabel)
        
        let costLabel = RegularGrayLabel(frame: CGRect(x: 32, y: 576, width: 200, height: 24))
        costLabel.text = "Стоимость запуска"
        verticalScrollView.addSubview(costLabel)
        
        let costDataLabel = RegularWhiteLabel(frame: CGRect(x: view.frame.width - 232, y: 576, width: 200, height: 24))
        costDataLabel.text = "$" + String(rockets[index].costPerLaunch / 1000000) + " млн"
        verticalScrollView.addSubview(costDataLabel)
        
        //first step
        
        let fistStepGroupLabel = BoldLabel(frame: CGRect(x: 32, y: 640, width: 311, height: 24))
        fistStepGroupLabel.text = "ПЕРВАЯ СТУПЕНЬ"
        verticalScrollView.addSubview(fistStepGroupLabel)
        
        let amountEnginesFirstLabel = RegularGrayLabel(frame: CGRect(x: 32, y: 680, width: 200, height: 24))
        amountEnginesFirstLabel.text = "Количество двигателей"
        verticalScrollView.addSubview(amountEnginesFirstLabel)
        
        let amountEnginesFirstDataLabel = RegularWhiteLabel(frame: CGRect(x: view.frame.width - 264, y: 680, width: 200, height: 24))
        amountEnginesFirstDataLabel.text = String(rockets[index].firstStage.engines)
        verticalScrollView.addSubview(amountEnginesFirstDataLabel)
        
        let amountFuelFirstLabel = RegularGrayLabel(frame: CGRect(x: 32, y: 720, width: 200, height: 24))
        amountFuelFirstLabel.text = "Количество топлива"
        verticalScrollView.addSubview(amountFuelFirstLabel)
        
        let amountFuelFirstDataLabel = RegularWhiteLabel(frame: CGRect(x: view.frame.width - 264, y: 720, width: 200, height: 24))
        amountFuelFirstDataLabel.text = String(rockets[index].firstStage.fuelAmountTons)
        verticalScrollView.addSubview(amountFuelFirstDataLabel)
        
        let tonLabel = MetricLabel(frame: CGRect(x: view.frame.width - 232, y: 720, width: 200, height: 24))
        tonLabel.text = "ton"
        verticalScrollView.addSubview(tonLabel)
        
        let timeBurnFirstLabel = RegularGrayLabel(frame: CGRect(x: 32, y: 760, width: 200, height: 24))
        timeBurnFirstLabel.text = "Время сгорания"
        verticalScrollView.addSubview(timeBurnFirstLabel)
        
        let timeBurnFirstDataLabel = RegularWhiteLabel(frame: CGRect(x: view.frame.width - 264, y: 760, width: 200, height: 24))
        timeBurnFirstDataLabel.text = rockets[index].firstStage.burnTimeSEC?.formatted()
        verticalScrollView.addSubview(timeBurnFirstDataLabel)
        
        let secLabel = MetricLabel(frame: CGRect(x: view.frame.width - 232, y: 760, width: 200, height: 24))
        secLabel.text = "sec"
        verticalScrollView.addSubview(secLabel)
        
        //second step
        
        let secondStepGroupLabel = BoldLabel(frame: CGRect(x: 32, y: 824, width: 311, height: 24))
        secondStepGroupLabel.text = "ВТОРАЯ СТУПЕНЬ"
        verticalScrollView.addSubview(secondStepGroupLabel)
        
        let amountEnginesSecondLabel = RegularGrayLabel(frame: CGRect(x: 32, y: 864, width: 200, height: 24))
        amountEnginesSecondLabel.text = "Количество двигателей"
        verticalScrollView.addSubview(amountEnginesSecondLabel)
        
        let amountEnginesSecondDataLabel = RegularWhiteLabel(frame: CGRect(x: view.frame.width - 264, y: 864, width: 200, height: 24))
        amountEnginesSecondDataLabel.text = String(rockets[index].secondStage.engines)
        verticalScrollView.addSubview(amountEnginesSecondDataLabel)
        
        let amountFuelSecondLabel = RegularGrayLabel(frame: CGRect(x: 32, y: 904, width: 200, height: 24))
        amountFuelSecondLabel.text = "Количество топлива"
        verticalScrollView.addSubview(amountFuelSecondLabel)
        
        let amountFuelSecondDataLabel = RegularWhiteLabel(frame: CGRect(x: view.frame.width - 264, y: 904, width: 200, height: 24))
        amountFuelSecondDataLabel.text = String(rockets[index].secondStage.fuelAmountTons)
        verticalScrollView.addSubview(amountFuelSecondDataLabel)
        
        let tonsLabel = MetricLabel(frame: CGRect(x: view.frame.width - 232, y: 904, width: 200, height: 24))
        tonsLabel.text = "ton"
        verticalScrollView.addSubview(tonsLabel)
        
        let timeBurnSecondLabel = RegularGrayLabel(frame: CGRect(x: 32, y: 944, width: 200, height: 24))
        timeBurnSecondLabel.text = "Время сгорания"
        verticalScrollView.addSubview(timeBurnSecondLabel)
        
        let timeBurnSecondDataLabel = RegularWhiteLabel(frame: CGRect(x: view.frame.width - 264, y: 944, width: 200, height: 24))
        timeBurnSecondDataLabel.text = rockets[index].secondStage.burnTimeSEC?.formatted()
        verticalScrollView.addSubview(timeBurnSecondDataLabel)
        
        let secsLabel = MetricLabel(frame: CGRect(x: view.frame.width - 232, y: 944, width: 200, height: 24))
        secsLabel.text = "sec"
        verticalScrollView.addSubview(secsLabel)
        
        let buttonShowedLaunchs = UIButton(frame: CGRect(x: 70, y: 1008, width: view.frame.size.width-128, height: 56))
        buttonShowedLaunchs.setTitle("Показать запуски", for: .normal)
        buttonShowedLaunchs.setTitleColor(UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1), for: .normal)
        buttonShowedLaunchs.backgroundColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        buttonShowedLaunchs.titleLabel?.font = UIFont(name: "LabGrotesque-Bold", size: 16)
        buttonShowedLaunchs.layer.cornerRadius = 15
        buttonShowedLaunchs.addTarget(self, action: #selector(showLaunchs), for: .touchUpInside)
        buttonShowedLaunchs.tag = index
        verticalScrollView.addSubview(buttonShowedLaunchs)
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
        let secondController = LaunchViewController()
        secondController.rocketName = rockets[sender.tag].name
        secondController.rocketID = rockets[sender.tag].id
        navigationController?.pushViewController(secondController, animated: true)
    }
    
    func updateUnits(height: String, diameter: String, mass: String, payload: String) {
        unitHeight = height
        unitDiameter = diameter
        unitMass = mass
        unitPayload = payload
    }
}

extension RocketViewController: SettingViewControllerDelegate, RocketDataDelegate {
    func didRecieveDataUpdate(data: Rockets) {
        rockets = data
    }
}

extension RocketViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = configureUnitCell(collectionView: collectionView, indexPath: indexPath)
        return cell
    }
}

extension RocketViewController {
    func configureUnitCell(collectionView: UICollectionView, indexPath: IndexPath) -> UnitViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnitViewCell.identifier, for: indexPath) as! UnitViewCell
        
        switch indexPath.item {
        case 0:
            if unitHeight == "m" {
                cell.headLabel.text = String(rockets[collectionView.tag].height.meters ?? 0)
            }else {
                cell.headLabel.text = String(rockets[collectionView.tag].height.feet ?? 0)
            }
            cell.secondLabel.text = "Высота, " + unitHeight
        case 1:
            if unitDiameter == "m" {
                cell.headLabel.text = String(rockets[collectionView.tag].diameter.meters ?? 0)
            }else {
                cell.headLabel.text = String(rockets[collectionView.tag].diameter.feet ?? 0)
            }
            cell.secondLabel.text = "Диаметр, " + unitDiameter
        case 2:
            if unitMass == "kg" {
                cell.headLabel.text = String(rockets[collectionView.tag].mass.kg)
            }else {
                cell.headLabel.text = String(rockets[collectionView.tag].mass.lb)
            }
            cell.secondLabel.text = "Масса, " + unitMass
        case 3:
            if unitPayload == "kg" {
                cell.headLabel.text = String(rockets[collectionView.tag].payloadWeights[0].kg)
            }else {
                cell.headLabel.text = String(rockets[collectionView.tag].payloadWeights[0].lb)
            }
            cell.secondLabel.text = "Нагрузка, " + unitPayload
        default:
            break
        }
        
        collectionView.reloadData()
        return cell
    }
}

extension RocketViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / view.frame.size.width)
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


