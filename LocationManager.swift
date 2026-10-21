import Foundation
import CoreLocation

// Define a model for the station data
struct TrainStation: Decodable {
    let code: String
    let latitude: Double
    let longitude: Double
}

struct StationList: Decodable {
    let stations: [TrainStation]
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?
    private var stations: [(String, Double, Double)] = [] // Stores station code, latitude, and longitude

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()  // Request permission
        locationManager.startUpdatingLocation()
        fetchStations() // Fetch stations on initialization
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
        }

        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied.")
        case .notDetermined:
            print("Location access not determined.")
        @unknown default:
            print("Unknown authorization status.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        DispatchQueue.main.async {
            self.location = latestLocation
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error updating location: \(error.localizedDescription)")
    }

    // ✅ Fetches all stations from the NS-APP Stations API
    private func fetchStations() {
        let urlString = "https://gateway.apiportal.ns.nl/reisinformatie-api/api/v2/stations"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(StationList.self, from: data)
                    DispatchQueue.main.async {
                        self.stations = decodedResponse.stations.map { ($0.code, $0.latitude, $0.longitude) }
                        print("✅ Successfully loaded \(self.stations.count) stations.")
                    }
                } catch {
                    print("Error decoding stations: \(error)")
                }
            }
        }.resume()
    }

    // ✅ Determines the nearest station dynamically, returns nil if no data is available
    func getNearestStation(from location: CLLocation) -> String? {
        guard !stations.isEmpty else {
            print("⚠️ No station data available, returning nil")
            return nil
        }

        var nearestStation: String?
        var shortestDistance = Double.infinity

        for (stationCode, lat, lon) in stations {
            let stationLocation = CLLocation(latitude: lat, longitude: lon)
            let distance = location.distance(from: stationLocation)
            if distance < shortestDistance {
                shortestDistance = distance
                nearestStation = stationCode
            }
        }

        if let foundStation = nearestStation {
            print("🚆 Nearest station: \(foundStation)")
        } else {
            print("⚠️ No valid station found")
        }

        return nearestStation
    }
}

// ✅ Retrieve API key from Info.plist
private let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""

