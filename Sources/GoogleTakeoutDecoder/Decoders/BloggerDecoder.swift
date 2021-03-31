//
//  Created by msyk on 2021/03/25.
//

import Foundation

import class XMLCoder.XMLDecoder

struct BloggerDecoder {
    let fileManager: FileManager

    func decode(_ directoryPath: URL) throws -> Blogger {
        let contents = try fileManager.contentsOfDirectory(at: directoryPath, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])

        var blogger = Blogger(blogs: [])

        for content in contents {
            var fileExists: ObjCBool = false
            fileManager.fileExists(atPath: content.path, isDirectory: &fileExists)
            guard fileExists.boolValue else {
                continue
            }

            let feedURL =  content.appendingPathComponent("feed").appendingPathExtension("atom")
            guard fileManager.fileExists(atPath: feedURL.path) else {
                continue
            }

            let blog = try BlogDecoder().decode(feedURL)
            blogger.blogs.append(blog)
        }

        return blogger
    }
}

extension BloggerDecoder {
    struct BlogDecoder {
        private var xmlDecoder: XMLDecoder {
            let decoder = XMLDecoder()
            decoder.dateDecodingStrategy = .formatted(.init(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"))
            decoder.shouldProcessNamespaces = true
            return decoder
        }

        func decode(_ atom: URL) throws -> Blogger.Blog {
            let data = try Data(contentsOf: atom)

            return try xmlDecoder.decode(Blogger.Blog.self, from: data)
        }
    }
}

extension DateFormatter {
    fileprivate convenience init(format: String) {
        self.init()
        dateFormat = format
        locale = Locale(identifier: "en_US_POSIX")
        timeZone = TimeZone(secondsFromGMT: 0)!
        calendar = Calendar(identifier: .iso8601)
    }
}
