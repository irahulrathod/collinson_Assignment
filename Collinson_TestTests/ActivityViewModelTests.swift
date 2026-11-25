//
//  ActivityViewModelTests.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//

import XCTest
@testable import Collinson_Test
import Combine

final class ActivityViewModelTests: XCTestCase {
    var activityViewModel: ActivityViewModel?
    var city = City(name: "New York", latitude: 40.710335, longitude: -73.99308)
    var activityUsecase = ActivityUseCaseImplementation(repository: MockActivityRepository())
    var subscriptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        activityViewModel = ActivityViewModel(
            activityUsecase: ActivityUseCaseImplementation(
                repository: MockActivityRepository()
            ),
            city: city
        )
    }

    override func tearDownWithError() throws {
        activityViewModel = nil
    }
    
    func testGetActivity() {
        activityUsecase.getActivities(city: city)
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    break
                case .failure:
                    break
                }
            } receiveValue: { dayPlan in
                XCTAssertFalse(dayPlan.isEmpty)
                XCTAssertEqual(dayPlan.first?.forecast.date, "2026-11-259")
                XCTAssertNotEqual(self.activityViewModel?.loadingState, .loading)
            }
            .store(in: &subscriptions)
    }
    
}
