//
//  Created by msyk on 2021/03/25.
//

import Foundation

import class XMLCoder.XMLDecoder

struct BloggerDecoder {
    private var xmlDecoder: XMLDecoder {
        let decoder = XMLDecoder()
        decoder.dateDecodingStrategy = .formatted(.init(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"))
        decoder.shouldProcessNamespaces = true
        return decoder
    }

    func decode(_ directoryPath: URL) throws -> Blogger {
        let contents = try FileManager.default.contentsOfDirectory(at: directoryPath, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])

        var blogger = Blogger(blogs: [])

        for content in contents {
            var fileExists: ObjCBool = false
            FileManager.default.fileExists(atPath: content.path, isDirectory: &fileExists)
            guard fileExists.boolValue else {
                continue
            }

            let blog = try BlogDecoder(xmlDecoder: xmlDecoder).decode(content)
            blogger.blogs.append(blog)
        }

        return blogger
    }
}

extension BloggerDecoder {
    struct BlogDecoder {
        let xmlDecoder: XMLDecoder

        func decode(_ directoryPath: URL) throws -> Blogger.Blog {
            let url = directoryPath.appendingPathComponent("feed").appendingPathExtension("atom")
            let data = try Data(contentsOf: url)

            return try xmlDecoder.decode(Blogger.Blog.self, from: data)
        }
    }
}

extension DateFormatter {
    fileprivate convenience init(format: String) {
        self.init()
        dateFormat = format
        locale = Locale(identifier: "en_US")
        timeZone = TimeZone(secondsFromGMT: 0)!
        calendar = Calendar(identifier: .gregorian)
    }
}
