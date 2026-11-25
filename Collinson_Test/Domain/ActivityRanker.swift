//
//  ActivityRanker.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//
import Foundation

struct ActivityRanker  {
    func rank(_ day: ForecastDay) -> [Recommendation] {
        let temperature = day.meanTemperature
        let dry = 1 - day.precipitationProbability / 100
        let calm = max(0, 1 - day.maximumWindSpeed / 50)
        let comfort = max(0, 1 - abs(temperature - 21) / 21)
        let snow = min(day.snowfall / 5, 1)
        let cold = max(0, min(1, (5 - temperature) / 15))
        let warm = max(0, min(1, (temperature - 8) / 16))
        let severe = day.hasThunderstorm || day.maximumWindSpeed >= 60
        
        let outdoor = severe ? 0 : 100 * (0.45 * dry + 0.35 * comfort + 0.20 * calm)
        let skiing = severe ? 0 : 100 * (0.60 * cold + 0.25 * snow + 0.15 * calm)
        let surfing = severe ? 0 : 100 * (0.45 * warm + 0.30 * calm + 0.25 * dry)
        let indoor = 100 * (0.35 + 0.35 * (1 - dry) + 0.20 * (1 - comfort) + 0.10 * (1 - calm))
        
        let values: [(Activity, Double)] = [
            (.Skiing, skiing),
            (.Surfing, surfing),
            (.OutdoorSightseeing, outdoor),
            (.IndoorSightseeing, indoor)
        ]
        return sort(values.map { activity, score in
            Recommendation(activity: activity,
                           score: Int(min(100, max(0, score)).rounded()))
        })
    }
 
    private func sort(_ recommendations: [Recommendation]) -> [Recommendation] {
        recommendations.sorted {
            if $0.score == $1.score {
                return Activity.allCases.firstIndex(of: $0.activity)! < Activity.allCases.firstIndex(of: $1.activity)!
            }
            return $0.score > $1.score
        }
    }
}
