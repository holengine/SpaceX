//
//  Launch.swift
//  SpaceX
//
//  Created by Aleksandr Savinyh on 14.08.2022.
//

import Foundation

// MARK: - WelcomeElement
struct Launch: Codable {
    let rocket: RocketID
    let name, dateUTC: String
    let success: Bool?

    enum CodingKeys: String, CodingKey {
        case rocket
        case name
        case dateUTC = "date_utc"
        case success
    }
}

enum RocketID: String, Codable {
    case the5E9D0D95Eda69955F709D1Eb = "5e9d0d95eda69955f709d1eb"
    case the5E9D0D95Eda69973A809D1Ec = "5e9d0d95eda69973a809d1ec"
    case the5E9D0D95Eda69974Db09D1Ed = "5e9d0d95eda69974db09d1ed"
}

typealias Launches = [Launch]

