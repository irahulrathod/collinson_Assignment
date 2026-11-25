//
//  ForecastDay.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//

import Foundation

struct ForecastDay: Identifiable, Equatable, Sendable {
    let date: String
    let minimumTemperature: Double
    let maximumTemperature: Double
    let precipitationProbability: Double
    let snowfall: Double
    let maximumWindSpeed: Double
    let weatherCode: Int
    var id: String { date }
    var meanTemperature: Double { (minimumTemperature + maximumTemperature) / 2 }
    var hasThunderstorm: Bool { (95...99).contains(weatherCode) }
}

struct DayPlan: Identifiable, Equatable, Sendable {
    let forecast: ForecastDay
    let recommendations: [Recommendation]
    var id: String { forecast.id }
}

struct Recommendation: Identifiable, Equatable, Sendable {
    let activity: Activity
    let score: Int
    var id: Activity { activity }
}
