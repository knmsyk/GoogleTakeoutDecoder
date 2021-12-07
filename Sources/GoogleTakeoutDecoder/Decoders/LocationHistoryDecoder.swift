//
//  Created by msyk on 2021/12/07.
//

import Foundation

struct LocationHistoryDecoder {
    let fileManager: FileManager

    func decode(_ directoryPath: URL) throws -> LocationHistory {
        let fileURL = directoryPath.appendingPathComponent("Location History").appendingPathExtension("json")
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return .init(locations: [])
        }

        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(LocationHistory.self, from: data)
    }
}
