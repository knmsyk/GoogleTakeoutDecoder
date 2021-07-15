//
//  Created by msyk on 2021/07/15.
//

import Foundation

struct YouTubeDecoder {
    enum History: String, CaseIterable {
        case search, watch
        var fileName: String {
            switch self {
            case .search:
                return "search-history"
            case .watch:
                return "watch-history"
            }
        }
    }

    let fileManager: FileManager
    private let decoder = JSONDecoder(dateDecodingStrategy: .customISO8601)

    func decode(_ directoryPath: URL) throws -> YouTube {
        let historyDirectory = directoryPath.appendingPathComponent("history")
        var fileExists: ObjCBool = false
        fileManager.fileExists(atPath: historyDirectory.path, isDirectory: &fileExists)
        guard fileExists.boolValue else {
            return .init(searchHistory: [], watchHistory: [])
        }

        var searchHistory = [YouTube.Search]()
        var watchHistory = [YouTube.Watch]()

        for history in History.allCases {
            let fileURL = historyDirectory.appendingPathComponent(history.fileName).appendingPathExtension("json")
            guard fileManager.fileExists(atPath: fileURL.path) else {
                continue
            }

            let data = try Data(contentsOf: fileURL)
            switch history {
            case .search:
                searchHistory.append(contentsOf: try decoder.decode([YouTube.Search].self, from: data))
            case .watch:
                watchHistory.append(contentsOf: try decoder.decode([YouTube.Watch].self, from: data))
            }
        }

        return YouTube(searchHistory: searchHistory, watchHistory: watchHistory)
    }
}
