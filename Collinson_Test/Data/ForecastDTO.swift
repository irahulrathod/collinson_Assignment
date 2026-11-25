//
//  ForecastDTO.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//

import Foundation

struct ForecastDTO: Decodable {
    let daily: Daily
    struct Daily: Decodable {
        let time: [String]
        let temperature_2m_min: [Double?]
        let temperature_2m_max: [Double?]
        let precipitation_probability_max: [Double?]
        let snowfall_sum: [Double?]
        let wind_speed_10m_max: [Double?]
        let weather_code: [Int?]

        func toDomain() -> [ForecastDay] {
            
            return time.indices.map { index in
                      let low = temperature_2m_min[index] ?? 0
                      let high = temperature_2m_max[index]  ?? 0
                      let rain = precipitation_probability_max[index]  ?? 0
                      let snow = snowfall_sum[index] ?? 0
                      let wind = wind_speed_10m_max[index] ?? 0
                      let code = weather_code[index] ?? 0
                return ForecastDay(date: time[index],
                                   minimumTemperature: low,
                                   maximumTemperature: high,
                                   precipitationProbability: rain,
                                   snowfall: snow,
                                   maximumWindSpeed: wind,
                                   weatherCode: code)
            }
        }
    }
}
