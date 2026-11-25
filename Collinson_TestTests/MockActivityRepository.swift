//
//  MockActivityRepository.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//

import XCTest
@testable import Collinson_Test
import Combine

class MockActivityRepository: ActivityRepository {
    
    func getActivities(city: City) -> AnyPublisher<[ForecastDay], ServiceError> {
        Just([ForecastDay(date: "2026-11-25",
                                       minimumTemperature: 6.5,
                                       maximumTemperature: 13.8,
                                       precipitationProbability: 95,
                                       snowfall: 0.07,
                                       maximumWindSpeed: 31.5,
                                       weatherCode: 85)])
        .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
}
