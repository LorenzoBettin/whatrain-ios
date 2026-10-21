import Foundation

// Model for a train arrival
struct TrainArrival: Decodable, Identifiable {
    var id: UUID = UUID() // ✅ Allow decoding, assign default later
    let from: String?
    let name: String
    let plannedDateTime: String?
    let actualDateTime: String?
    let plannedTrack: String?
    let actualTrack: String?
    let cancelled: Bool
    let trainCategory: String

    enum CodingKeys: String, CodingKey {
        case id, from, name, plannedDateTime, actualDateTime, plannedTrack, actualTrack, cancelled, trainCategory
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID() // ✅ Assign default UUID if missing
        from = try container.decodeIfPresent(String.self, forKey: .from)
        name = try container.decode(String.self, forKey: .name)
        plannedDateTime = try container.decodeIfPresent(String.self, forKey: .plannedDateTime)
        actualDateTime = try container.decodeIfPresent(String.self, forKey: .actualDateTime)
        plannedTrack = try container.decodeIfPresent(String.self, forKey: .plannedTrack)
        actualTrack = try container.decodeIfPresent(String.self, forKey: .actualTrack)
        cancelled = try container.decode(Bool.self, forKey: .cancelled)
        trainCategory = try container.decode(String.self, forKey: .trainCategory)
    }
}

// API response payload for train arrivals
struct TrainArrivalsPayload: Decodable {
    let arrivals: [TrainArrival]
}

// Model for a train departure
struct Departure: Decodable, Identifiable {
    var id: UUID? // ✅ Allow decoding, assign default later
    let destination: String?
    let name: String
    let plannedDateTime: String?
    let actualDateTime: String?
    let plannedTrack: String?
    let actualTrack: String?
    let cancelled: Bool
    let trainCategory: String

    enum CodingKeys: String, CodingKey {
        case id, destination, name, plannedDateTime, actualDateTime, plannedTrack, actualTrack, cancelled, trainCategory
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID() // ✅ Assign default UUID if missing
        destination = try container.decodeIfPresent(String.self, forKey: .destination)
        name = try container.decode(String.self, forKey: .name)
        plannedDateTime = try container.decodeIfPresent(String.self, forKey: .plannedDateTime)
        actualDateTime = try container.decodeIfPresent(String.self, forKey: .actualDateTime)
        plannedTrack = try container.decodeIfPresent(String.self, forKey: .plannedTrack)
        actualTrack = try container.decodeIfPresent(String.self, forKey: .actualTrack)
        cancelled = try container.decode(Bool.self, forKey: .cancelled)
        trainCategory = try container.decode(String.self, forKey: .trainCategory)
    }
}

// API response payload for departures
struct DeparturesPayload: Decodable {
    let departures: [Departure]
}

// Model for a station
struct Station: Identifiable {
    var id = UUID() // ✅ No need for `Decodable`
    let code: String
    let name: String
    let arrivalTime: String
}

// Model for train schedule details
struct TrainSchedule: Identifiable {
    var id = UUID() // ✅ No need for `Decodable`
    let trainNumber: String
    let departureTime: String
}

