//
//  LaunchData.swift
//  SpaceX
//
//  Created by Aleksandr Savinyh on 18.08.2022.
//

import Foundation
import Alamofire

protocol LaunchDataDelegate: AnyObject {
    func didRecieveDataUpdate(data: Launches)
}

class LaunchData {
    weak var delegate: LaunchDataDelegate?
    
    func requestData() {
        let request =  AF.request("https://api.spacexdata.com/v4/launches").validate()
        request.responseDecodable(of: Launches.self) { response in
            guard let launches = response.value else {return}
            self.setDataWithResponseValue(response: launches)
        }
    }
    
    private func setDataWithResponseValue(response: Launches) {
        let data: Launches = response
        delegate?.didRecieveDataUpdate(data: data)
    }
}
