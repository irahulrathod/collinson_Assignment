//
//  CityCoordinatesDTO.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//

import Foundation

class CityCoordinatesDTO: Codable {
    var results: [Coordinates]
}

class Coordinates: Codable {
    var latitude: Double
    var longitude: Double
    var name: String
}
