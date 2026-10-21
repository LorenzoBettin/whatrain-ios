import SwiftUI

struct StationDetailsView: View {
    let stationCode: String
    @State private var schedules: [TrainSchedule] = [] // ✅ Uses TrainSchedule from Models.swift
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            Text("Station: \(stationCode)")
                .font(.largeTitle)
                .bold()
            
            if isLoading {
                ProgressView("Loading schedules...")
            } else if schedules.isEmpty {
                Text("No schedules available.")
                    .foregroundColor(.gray)
            } else {
                List(schedules) { schedule in
                    VStack(alignment: .leading) {
                        Text("Train \(schedule.trainNumber)")
                            .font(.headline)
                        Text("Departure: \(schedule.departureTime)")
                    }
                }
            }

        }
        .onAppear {
            let trainDataManager = TrainDataManager() // ✅ Create an instance of TrainDataManager
            trainDataManager.fetchDepartures(for: stationCode) // ✅ Call function through instance
        }


        .padding()
    }
    
    func fetchSchedule() {
        // Simulated API response delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.schedules = [
                TrainSchedule(trainNumber: "IC 1342", departureTime: "14:30"),
                TrainSchedule(trainNumber: "Sprinter 982", departureTime: "14:45"),
                TrainSchedule(trainNumber: "Thalys 9234", departureTime: "15:00")
            ]
            self.isLoading = false
        }
    }
}

