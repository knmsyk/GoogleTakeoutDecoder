//
//  Created by msyk on 2021/12/07.
//

import Foundation

public struct LocationHistory: Decodable {
    public let locations: [Location]
}

extension LocationHistory {
    public struct Location: Decodable {
        public let timestampMs: String
        public let latitudeE7: Int
        public let longitudeE7: Int
        public let accuracy: Int
        public let activity: [Activity]?

        public var timestamp: Date {
            Date(timeIntervalSince1970: Double(timestampMs)! / 1000.0)
        }
        public var latitude: Decimal {
            Decimal(latitudeE7) / pow(10, 7)
        }
        public var longitude: Decimal {
            Decimal(longitudeE7) / pow(10, 7)
        }
    }

    public struct Activity: Decodable {
        public struct Value: Decodable {
            public let type: String
            public let confidence: Int
        }

        public let timestampMs: String
        public let activity: [Value]

        public var timestamp: Date {
            Date(timeIntervalSince1970: Double(timestampMs)! / 1000.0)
        }
    }
}
