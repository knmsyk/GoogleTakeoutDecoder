//
//  Created by msyk on 2021/07/11.
//

import Foundation

public struct Search {
    public enum Product: String, CaseIterable {
        case text = "Search"
        case image = "Image Search"
        case video = "Video Search"
        case maps = "Maps"

        public var directoryName: String { rawValue }
    }

    public let activities: [Activity]
}

extension Search {
    public struct Activity {
        public let product: Product
        public let items: [Item]
    }

    public struct Item: Decodable {
        public let header: String
        public let title: String
        public let titleUrl: URL?
        public let description: String?
        public let time: Date
        public let products: [String]
        public let locationInfos: [LocationInfo]?
    }

    public struct LocationInfo: Decodable {
        public let name: String?
        public let url: URL?
        public let source: String?
        public let sourceUrl: URL?
    }
}
