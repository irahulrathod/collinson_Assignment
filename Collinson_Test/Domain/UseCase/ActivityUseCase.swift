//
//  ActivityUseCase.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//

import Combine
import Foundation

protocol ActivityUseCase {
    func getActivities(city: City) -> AnyPublisher<[DayPlan], ServiceError>
}

protocol ActivityRepository {
    func getActivities(city: City) -> AnyPublisher<[ForecastDay], ServiceError>
}

class ActivityUseCaseImplementation: ActivityUseCase {
    var repository: ActivityRepository
    var subscriptions = Set<AnyCancellable>()
    
    init(repository: ActivityRepository) {
        self.repository = repository
    }
    
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
            .store(in: &subscriptions)
        return subject.eraseToAnyPublisher()

    }
}
