//
//  MockAactivityUsecase.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//

import XCTest
@testable import Collinson_Test
import Combine

class MockAactivityUsecase: ActivityUseCase {
    var repository = MockActivityRepository()
    var canellable = Set<AnyCancellable>()
    
    func getActivities(city: City) -> AnyPublisher<[DayPlan], ServiceError> {
        let subject = PassthroughSubject<[DayPlan], ServiceError>()
        
        let ranker = ActivityRanker()
        repository.getActivities(city: city)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    subject.send(completion: .failure(error))
                    break
                }
            } receiveValue: { response in
                let recommendation = response.map { forecastDay in
                    DayPlan(forecast: forecastDay, recommendations: ranker.rank(forecastDay))
                }
                subject.send(recommendation)
            }
            .store(in: &canellable)
        return subject.eraseToAnyPublisher()
    }
}
