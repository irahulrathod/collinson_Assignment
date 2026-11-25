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
            NavigationLink("New York", destination: ActivitiesView(viewModel: ActivityViewModel()))
        }
        .navigationTitle("Search city")
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search City"))
    }
}

#Preview {
    LandingView()
}
