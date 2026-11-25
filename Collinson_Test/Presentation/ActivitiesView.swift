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
            
            ProgressView {
                Text("Loading")
            }
        }
        .navigationTitle("Activities")
    }
}

