//
//  LandingViewModel.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//

import Combine
import Foundation

enum Activity: String, CaseIterable, Identifiable {
    case Skiing
    case Surfing
    case OutdoorSightseeing
    case IndoorSightseeing
    var id: String { rawValue }
}

class LandingViewModel: ObservableObject {
    
    enum LandingViewLoading {
        case loading(String)
        case success([City])
        case failure(String)
    }
    
    private var citySearchUsecase: CitySearchUseCase
    @Published var searchText: String = ""
    @Published var loadingState: LandingViewLoading = .loading("Search your city...")
    private var cancellable = Set<AnyCancellable>()

    init(citySearchUsecase: CitySearchUseCase = CitySearchUseCaseImplementation(repository:
                                                                                    CitySearchProvider(service: APIServiceImplemenation()))) {
        self.citySearchUsecase = citySearchUsecase
        setupSearch()
    }
    
    func getCities(cityName: String) {
        loadingState = .loading("Search your city...")
        self.citySearchUsecase.getCity(cityName: cityName)
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self.loadingState = .failure(error.localizedDescription)
                    break
                }
            } receiveValue: { cities in
                self.loadingState = .success(cities)
            }
            .store(in: &cancellable)
    }
    
    func setupSearch() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink(receiveValue: { query in
                if query.count > 2 {
                    self.getCities(cityName: query)
                } else {
                    self.loadingState = .success([])
                }
            })
            .store(in: &cancellable)
    }
}

