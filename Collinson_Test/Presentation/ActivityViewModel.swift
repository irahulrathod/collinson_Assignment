//
//  ActivityViewModel.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//

import Combine
import Foundation

class ActivityViewModel: ObservableObject {
    enum LoadingState: Equatable {
        case success([DayPlan])
        case failure(String)
        case loading
    }
    private var activityUsecase: ActivityUseCase
    private var subscriptions = Set<AnyCancellable>()
    var city: City
    @Published var loadingState = LoadingState.loading
    
    init(activityUsecase: ActivityUseCase = ActivityUseCaseImplementation(repository: ActivityProvider(service: APIServiceImplemenation())), city: City) {
        self.activityUsecase = activityUsecase
        self.city = city
    }
    
    func getActivities(city: City) {
        loadingState = .loading
        activityUsecase.getActivities(city: city)
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self.loadingState = .failure(error.localizedDescription)
                    break
                }
            } receiveValue: { dayPlan in
                self.loadingState = .success(dayPlan)
            }
            .store(in: &subscriptions)
        
    }
}
