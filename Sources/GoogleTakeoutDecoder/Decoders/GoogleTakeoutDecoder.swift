//
//  Created by msyk on 2021/03/24.
//

import Foundation
import ZIPFoundation

import class XMLCoder.XMLDecoder

public struct GoogleTakeoutDecoder {
    private let dataSources: [DataSource]
    private let destination: URL
    private let rootDirectory: URL
    private let fileManager: FileManager

    public init(_ dataSources: [DataSource] = DataSource.allCases, destination: URL? = nil, fileManager: FileManager = .default) {
        self.dataSources = dataSources
        self.destination = destination ?? fileManager.temporaryDirectory.appendingPathComponent("GoogleTakeoutDecoder/")
        self.rootDirectory = self.destination.appendingPathComponent("Takeout/")
        self.fileManager = fileManager
    }

    public func decode(_ file: URL) throws -> GoogleTakeout {
        let destination = try unzip(file)
        defer {
            try? fileManager.removeItem(at: destination)
        }

        var object = GoogleTakeout()

        for dataSource in dataSources {
            switch dataSource {
            case .blogger:
                let directoryPath = rootDirectory.appendingPathComponent(dataSource.directoryPath)
                object.blogger = try BloggerDecoder(fileManager: fileManager).decode(directoryPath)
            }
        }

        return object
    }

    private func unzip(_ file: URL) throws -> URL {
        if fileManager.fileExists(atPath: rootDirectory.path) {
            try fileManager.removeItem(at: rootDirectory)
        }
        try fileManager.unzipItem(at: file, to: destination)

        return destination
    }
}
