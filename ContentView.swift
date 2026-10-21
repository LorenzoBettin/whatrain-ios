
    import SwiftUI

    struct ContentView: View {
        @StateObject private var trainDataManager = TrainDataManager()
        
        var body: some View {
            NavigationView {
                VStack {
                    // Logo Image
                    Image("appstore") // Reference your image name without the file extension
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100) // Adjust size as needed
                        .padding(.bottom, 10)
                    
                    // Title
                    Text("Train Information")
                        .font(.largeTitle)
                        .bold()
                    
                    if let nextStation = trainDataManager.nextStation,
                       let arrivalTime = trainDataManager.nextArrivalTime {
                        VStack {
                            Text("Next Station: \(nextStation)")
                                .font(.title2)
                            Text("Arrival Time: \(arrivalTime)")
                                .font(.headline)
                            
                            NavigationLink(destination: StationDetailsView(stationCode: nextStation)) {
                                Text("View Station Schedule")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    } else {
                        VStack {
                            Text("Loading Data...")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onAppear {
                    let locationManager = LocationManager() // ✅ Create an instance of LocationManager

                    if let location = locationManager.location {
                        if let nearestStation = locationManager.getNearestStation(from: location) { // ✅ Access method correctly
                            trainDataManager.fetchArrivals(for: nearestStation)
                        } else {
                            print("⚠️ No nearest station found, skipping API call")
                        }
                    } else {
                        trainDataManager.fetchArrivals(for: "RTD") // Default fallback
                    }
                }

            }
            
        }
    }
