//
//  ActivitiesView.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//

import SwiftUI

struct ActivitiesView: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    var body: some View {
        VStack {
            switch viewModel.loadingState {
            case .loading:
                ProgressView {
                    Text("Loading")
                }
            case .success(let dayPlan):
                List {
                    ForEach(dayPlan) { activity in
                        Section {
                            Text(activity.forecast.date)
                        }
                        ForEach(activity.recommendations) { day in
                            HStack {
                                Text(day.activity.rawValue)
                                Text("\(day.score)")
                            }
                        }
                    }
                }
            case .failure(let error):
                Text(error)
            }
        }
        .navigationTitle("Activities")
        .onAppear {
            viewModel.getActivities(city: viewModel.city)
        }
    }
}

