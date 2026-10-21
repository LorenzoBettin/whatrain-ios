import Foundation
import Combine

class TrainDataManager: ObservableObject {
    @Published var nextStation: String? = nil
    @Published var nextArrivalTime: String? = nil
    @Published var upcomingStations: [Station] = []
    @Published var arrivals: [TrainArrival] = []

    private var cancellables = Set<AnyCancellable>()
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""

    func fetchArrivals(for stationCode: String) {
        let urlString = "https://gateway.apiportal.ns.nl/reisinformatie-api/api/v2/arrivals?station=\(stationCode)&maxJourneys=10"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")

        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: TrainArrivalsPayload.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching arrivals: \(error)")
                }
            }, receiveValue: { [weak self] payload in
                self?.arrivals = payload.arrivals
            })
            .store(in: &cancellables)
    }
    func fetchDepartures(for stationCode: String) {
        let urlString = "https://gateway.apiportal.ns.nl/reisinformatie-api/api/v2/departures?station=\(stationCode)&maxJourneys=10"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")

        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: DeparturesPayload.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching departures: \(error)")
                }
            }, receiveValue: { [weak self] payload in
                self?.arrivals = payload.departures.map {TrainArrival(
                    from: $0.destination ?? "Unknown",
                    name: $0.name,
                    plannedDateTime: $0.plannedDateTime ?? "N/A",
                    actualDateTime: $0.actualDateTime ?? "N/A",
                    plannedTrack: $0.plannedTrack ?? "N/A",
                    actualTrack: $0.actualTrack ?? "N/A",
                    cancelled: $0.cancelled ?? false,
                    trainCategory: $0.trainCategory ?? "Unknown"
                )
                }

            })
        .store(in: &cancellables)
    }



    func fetchUpcomingStations(for stationCode: String) {
        let urlString = "https://gateway.apiportal.ns.nl/reisinformatie-api/api/v2/arrivals?station=\(stationCode)&maxJourneys=5"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")

        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: TrainArrivalsPayload.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching upcoming stations: \(error)")
                }
            }, receiveValue: { [weak self] payload in
                self?.upcomingStations = payload.arrivals.map {
                    Station(code: $0.from ?? "Unknown", name: $0.name, arrivalTime: $0.plannedDateTime ?? "N/A")
                }
            })
            .store(in: &cancellables) // Store the subscription
    }
}

