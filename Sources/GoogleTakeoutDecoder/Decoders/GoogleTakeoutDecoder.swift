//
//  Created by msyk on 2021/03/24.
//

import Foundation
import ZIPFoundation

import class XMLCoder.XMLDecoder

public struct GoogleTakeoutDecoder {
    private let dataSources: [DataSource]

    public init(_ dataSources: [DataSource] = DataSource.allCases) {
        self.dataSources = dataSources
    }

    public func decode(_ file: URL) throws -> GoogleTakeout {
        let destination = try unzip(file)
        defer {
            try? FileManager.default.removeItem(at: destination)
        }

        let rootDirectory = destination.appendingPathComponent("Takeout/")

        var object = GoogleTakeout()

        for dataSource in dataSources {
            switch dataSource {
            case .blogger:
                let directoryPath = rootDirectory.appendingPathComponent(dataSource.directoryPath)
                object.blogger = try BloggerDecoder().decode(directoryPath)
            }
        }

        return object
    }

    private func unzip(_ file: URL) throws -> URL {
        let destination = FileManager.default.temporaryDirectory.appendingPathComponent("dest/")
        try FileManager.default.unzipItem(at: file, to: destination)

        return destination
    }
}
