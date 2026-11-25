//
//  LandingViewModel.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//

import Combine

enum Activity: String {
    case Skiing
    case Surfing
    case OutdoorSightseeing
    case IndoorSightseeing
}

class LandingViewModel: ObservableObject {
    @Published var searchText: String = ""

}
