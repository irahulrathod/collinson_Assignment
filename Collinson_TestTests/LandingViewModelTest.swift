//
//  LandingViewModelTest.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//

import XCTest
@testable import Collinson_Test
import Combine

final class LandingViewModelTest: XCTestCase {
    var viewModel: LandingViewModel?
    var city = City(name: "New York", latitude: 40.710335, longitude: -73.99308)
    var citySearchUsecase = CitySearchUseCaseImplementation(repository: MockCitySearchRepository())
    var subscriptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        viewModel = LandingViewModel(citySearchUsecase: citySearchUsecase)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testGetActivity() {
        citySearchUsecase.getCity(cityName: "New York")
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    break
                case .failure:
                    break
                }
            } receiveValue: { cities in
                XCTAssertFalse(cities.isEmpty)
                XCTAssertEqual(cities.first?.name, "New York")
            }
            .store(in: &subscriptions)
    }
}
