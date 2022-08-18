//
//  Rocket.swift
//  SpaceX
//
//  Created by Aleksandr Savinyh on 07.08.2022.
//

import Foundation

// MARK: - Rocket
struct Rocket: Codable {
    let id: String
    let name: String
    let height, diameter: Diameter
    let mass: Mass
    let payloadWeights: [PayloadWeight]
    let firstStage: FirstStage
    let secondStage: SecondStage
    let engines: Engines
    let flickrImages: [String]
    let costPerLaunch: Int
    let firstFlight: String
    let country: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case height, diameter, mass
        case payloadWeights = "payload_weights"
        case firstStage = "first_stage"
        case secondStage = "second_stage"
        case engines
        case flickrImages = "flickr_images"
        case costPerLaunch = "cost_per_launch"
        case firstFlight = "first_flight"
        case country
    }
}

// MARK: - Diameter
struct Diameter: Codable {
    let meters, feet: Double?
}

// MARK: - Engines
struct Engines: Codable {
    let number: Int

    enum CodingKeys: String, CodingKey {
        case number
    }
}

// MARK: - Thrust
struct Thrust: Codable {
    let kN, lbf: Int
}

// MARK: - FirstStage
struct FirstStage: Codable {
    let thrustSeaLevel, thrustVacuum: Thrust
    let reusable: Bool
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSEC: Int?

    enum CodingKeys: String, CodingKey {
        case thrustSeaLevel = "thrust_sea_level"
        case thrustVacuum = "thrust_vacuum"
        case reusable, engines
        case fuelAmountTons = "fuel_amount_tons"
        case burnTimeSEC = "burn_time_sec"
    }
}

// MARK: - Mass
struct Mass: Codable {
    let kg, lb: Int
}

// MARK: - PayloadWeight
struct PayloadWeight: Codable {
    let kg, lb: Int
}

// MARK: - SecondStage
struct SecondStage: Codable {
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSEC: Int?

    enum CodingKeys: String, CodingKey {
        case engines
        case fuelAmountTons = "fuel_amount_tons"
        case burnTimeSEC = "burn_time_sec"
    }
}

typealias Rockets = [Rocket]
