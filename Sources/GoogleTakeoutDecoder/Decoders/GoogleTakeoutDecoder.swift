//
//  Created by msyk on 2021/03/24.
//

import Foundation
import ZIPFoundation

import class XMLCoder.XMLDecoder

public struct GoogleTakeoutDecoder {
    private let dataSources: [DataSource]
    private let fileManager: FileManager
    private let destination: URL

    public init(_ dataSources: [DataSource] = DataSource.allCases, fileManager: FileManager = .default) {
        self.dataSources = dataSources
        self.fileManager = fileManager
        self.destination = fileManager.temporaryDirectory.appendingPathComponent("GoogleTakeoutDecoder/")
    }

    public func decode(_ file: URL) throws -> GoogleTakeout {
        try unzip(file)
        defer {
            try? fileManager.removeItem(at: destination)
        }

        var object = GoogleTakeout()

        for dataSource in dataSources {
            let directory = directory(of: dataSource)
            switch dataSource {
            case .search:
                object.search = try SearchDecoder(fileManager: fileManager).decode(directory)
            case .blogger:
                object.blogger = try BloggerDecoder(fileManager: fileManager).decode(directory)
            }
        }

        return object
    }

    private func directory(of dataSource: DataSource) -> URL {
        destination
            .appendingPathComponent("Takeout/")
            .appendingPathComponent(dataSource.directoryPath)
    }

    private func unzip(_ file: URL) throws {
        if fileManager.fileExists(atPath: destination.path) {
            try fileManager.removeItem(at: destination)
        }
        try fileManager.unzipItem(at: file, to: destination)
    }
}
