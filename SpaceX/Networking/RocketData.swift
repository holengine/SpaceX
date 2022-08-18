//
//  RocketData.swift
//  SpaceX
//
//  Created by Aleksandr Savinyh on 18.08.2022.
//

import Foundation
import Alamofire

protocol RocketDataDelegate: AnyObject {
    func didRecieveDataUpdate(data: Rockets)
}

class RocketData {
    weak var delegate: RocketDataDelegate?
    
    func requestData() {
        let request =  AF.request("https://api.spacexdata.com/v4/rockets").validate()
        request.responseDecodable(of: Rockets.self) { response in
            guard let rockets = response.value else {return}
            self.setDataWithResponseValue(response: rockets)
        }
    }
    
    private func setDataWithResponseValue(response: Rockets) {
        let data: Rockets = response
        delegate?.didRecieveDataUpdate(data: data)
    }
}
