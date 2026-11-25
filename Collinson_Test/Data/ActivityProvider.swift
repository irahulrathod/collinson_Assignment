//
//  ActivityProvider.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//

import Combine
import Foundation

class ActivityProvider: ActivityRepository {
    
    var subscriptions = Set<AnyCancellable>()
    private let service: APIService

    init(service: APIService) {
        self.service = service
    }
    
    func getActivities(city: City) -> AnyPublisher<[ForecastDay], ServiceError> {
        let subject = PassthroughSubject<[ForecastDay], ServiceError>()

        service.executeService(endpoint: String(format: Constant.weatherEndPoint,
                                                arguments: [city.latitude, city.longitude]),
                               responseModel: ForecastDTO.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    subject.send(completion: .finished)
                case .failure(let error):
                    subject.send(completion: .failure(error))
                }
            } receiveValue: { response in
                
                let mapArray = response.daily.toDomain()
                subject.send(mapArray)
            }
            .store(in: &subscriptions)

        return subject.eraseToAnyPublisher()
    }
}
