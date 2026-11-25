//
//  CitySearchProvider.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//

import Foundation
import Combine

class CitySearchProvider: CitySearchRepository {
    var subscriptions = Set<AnyCancellable>()
    private let service: APIService

    init(service: APIService) {
        self.service = service
    }
    
    func getCity(cityName: String) -> AnyPublisher<[City], ServiceError> {
        let subject = PassthroughSubject<[City], ServiceError>()

        service.executeService(endpoint: String(format: Constant.searchCityEndPoint,
                                                arguments: [cityName]),
                               responseModel: CityCoordinatesDTO.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    subject.send(completion: .finished)
                case .failure(let error):
                    subject.send(completion: .failure(error))
                }
            } receiveValue: { response in
                let mapArray = response.results.map { cordinates in
                    City(name: cordinates.name,
                                      latitude: cordinates.latitude,
                                      longitude: cordinates.longitude)
                }
                
                subject.send(mapArray)
            }
            .store(in: &subscriptions)

        return subject.eraseToAnyPublisher()
    }
}
