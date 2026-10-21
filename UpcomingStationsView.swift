//
//  UpcomingStationsView.swift
//  WhaTrain
//
//  Created by Lorenzo Bettin on 16/02/25.
//
import SwiftUI

struct UpcomingStationsView: View {
    var stationCode: String
    @ObservedObject private var trainDataManager = TrainDataManager()
    
    var body: some View {
        VStack {
            Text("Upcoming Stations")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            List(trainDataManager.upcomingStations, id: \.code) { station in
                NavigationLink(destination: StationDetailsView(stationCode: station.code)) {
                    HStack {
                        Text(station.name)
                            .font(.title2)
                        Spacer()
                        Text("Arrival: \(station.arrivalTime)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                trainDataManager.fetchUpcomingStations(for: stationCode)
            }
        }
    }
}
