//
//  City.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//

import Foundation

struct City: Identifiable, Equatable, Sendable {
    let id: Int = UUID().hashValue
    let name: String
    let latitude: Double
    let longitude: Double
}
