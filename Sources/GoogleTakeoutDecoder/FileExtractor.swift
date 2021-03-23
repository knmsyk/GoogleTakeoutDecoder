//
//  Copyright © 2021 msyk. All rights reserved.
//

import AppleArchive
import Foundation
import System

struct FileExtractor {
    init(path: FilePath) {
        guard let readFileStream = ArchiveByteStream.fileStream(
                path: path,
                mode: .readOnly,
                options: [ ],
                permissions: FilePermissions(rawValue: 0o644)) else {
            return
        }
        defer {
            try? readFileStream.close()
        }

        guard let decompressStream = ArchiveByteStream.decompressionStream(readingFrom: readFileStream) else {
            return
        }
        defer {
            try? decompressStream.close()
        }

        guard let decodeStream = ArchiveStream.decodeStream(readingFrom: decompressStream) else {
            print("unable to create decode stream")
            return
        }
        defer {
            try? decodeStream.close()
        }

        let decompressPath = NSTemporaryDirectory() + "dest/"

        if !FileManager.default.fileExists(atPath: decompressPath) {
            do {
                try FileManager.default.createDirectory(atPath: decompressPath,
                                                        withIntermediateDirectories: false)
            } catch {
                fatalError("Unable to create destination directory.")
            }
        }

        let decompressDestination = FilePath(decompressPath)

        guard let extractStream = ArchiveStream.extractStream(extractingTo: decompressDestination,
                                                              flags: [.ignoreOperationNotPermitted]) else {
            return
        }
        defer {
            try? extractStream.close()
        }

        do {
            _ = try ArchiveStream.process(readingFrom: decodeStream,
                                          writingTo: extractStream)
        } catch {
            print("process failed")
        }
    }
    
}
