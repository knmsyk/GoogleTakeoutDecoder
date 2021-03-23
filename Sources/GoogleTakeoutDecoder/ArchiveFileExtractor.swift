//
//  Copyright © 2021 msyk. All rights reserved.
//

import AppleArchive
import Foundation
import System

public enum ArchiveFileExtractorError: Error  {
    case invalidFile
    case invalidDestination
    case archiveError(ArchiveError)
    case unknown
}

public struct ArchiveFileExtractor {
    private let defaultDecompressPath: FilePath = FilePath(FileManager.default.temporaryDirectory.appendingPathComponent("dest").path)

    public func extract(filePath: FilePath, to destinationDirectoryPath: FilePath? = nil) throws -> FilePath {
        guard let readFileStream = ArchiveByteStream.fileStream(
                path: filePath,
                mode: .readOnly,
                options: [],
                permissions: FilePermissions(rawValue: 0o644)) else {
            throw ArchiveFileExtractorError.invalidFile
        }
        defer {
            try? readFileStream.close()
        }

        guard let decompressStream = ArchiveByteStream.decompressionStream(readingFrom: readFileStream) else {
            throw ArchiveFileExtractorError.invalidFile
        }
        defer {
            try? decompressStream.close()
        }

        guard let decodeStream = ArchiveStream.decodeStream(readingFrom: decompressStream) else {
            fatalError("Unable to create decode stream")
        }
        defer {
            try? decodeStream.close()
        }

        let decompressPath = String(decoding: destinationDirectoryPath ?? defaultDecompressPath)

        if !FileManager.default.fileExists(atPath: decompressPath) {
            do {
                try FileManager.default.createDirectory(atPath: decompressPath, withIntermediateDirectories: false)
            } catch {
                throw ArchiveFileExtractorError.invalidDestination
            }
        }

        let decompressDestination = FilePath(decompressPath)

        guard let extractStream = ArchiveStream.extractStream(extractingTo: decompressDestination,
                                                              flags: [.ignoreOperationNotPermitted]) else {
            throw ArchiveFileExtractorError.invalidDestination
        }
        defer {
            try? extractStream.close()
        }

        do {
            let number = try ArchiveStream.process(readingFrom: decodeStream, writingTo: extractStream)
            guard number == 1 else {
                throw ArchiveFileExtractorError.unknown
            }
        } catch let error as ArchiveError {
            throw ArchiveFileExtractorError.archiveError(error)
        }

        return decompressDestination
    }
    
}
