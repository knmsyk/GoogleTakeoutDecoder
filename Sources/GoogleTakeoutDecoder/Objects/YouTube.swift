//
//  Created by msyk on 2021/07/15.
//

import Foundation

public struct YouTube {
    public let searchHistory: [Search]
    public let watchHistory: [Watch]
}

extension YouTube {
    public struct Search: Decodable {
        public let header: String
        public let title: String
        public let titleUrl: URL?
        public let time: Date
        public let products: [String]
    }

    public struct Watch: Decodable {
        public let header: String
        public let title: String
        public let titleUrl: URL?
        public let subtitles: [Subtitle]?
        public let description: String?
        public let time: Date
        public let products: [String]

        public struct Subtitle: Decodable {
            public let name: String?
            public let url: URL?
        }
    }
}
