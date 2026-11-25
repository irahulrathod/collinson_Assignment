//
//  CitySearchUseCase.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//

import Combine
import Foundation

protocol CitySearchRepository {
    func getCity(cityName: String) -> AnyPublisher<[City], ServiceError>
}

protocol CitySearchUseCase {
    func getCity(cityName: String) -> AnyPublisher<[City], ServiceError>
}

class CitySearchUseCaseImplementation: CitySearchUseCase {
    var repository: CitySearchRepository
    var subscriptions = Set<AnyCancellable>()

    init(repository: CitySearchRepository) {
        self.repository = repository
    }
    
    func getCity(cityName: String) -> AnyPublisher<[City], ServiceError> {
        let subject = PassthroughSubject<[City], ServiceError>()
        
        repository.getCity(cityName: cityName)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    subject.send(completion: .finished)
                case .failure(let error):
                    subject.send(completion: .failure(error))
                }
            } receiveValue: { result in
                subject.send(result)
            }
            .store(in: &subscriptions)

        return subject.eraseToAnyPublisher()

    }
}
