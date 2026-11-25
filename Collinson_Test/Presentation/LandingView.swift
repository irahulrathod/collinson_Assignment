//
//  LandingView.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//
import SwiftUI

struct LandingView: View {
    @StateObject var viewModel = LandingViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.loadingState {
            case .loading(let msg):
                ProgressView {
                    Text(msg)
                }
            case .success(let array):
                List {
                    ForEach(array, id: \.id) { city in
                        NavigationLink(city.name, destination: ActivitiesView(viewModel: ActivityViewModel(city: city)))
                    }
                }

            case .failure(let message):
                Text(message)
            }
        }
        .navigationTitle("Search city")
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search City"))
    }
}

#Preview {
    LandingView()
}
