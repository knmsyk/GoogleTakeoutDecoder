//
//  Created by msyk on 2021/03/25.
//

import Foundation

import class XMLCoder.XMLDecoder

struct BloggerDecoder {
    let fileManager: FileManager

    func decode(_ directoryPath: URL) throws -> Blogger {
        let blogsDirectory = directoryPath.appendingPathComponent("Blogs")
        let contents = try fileManager.contentsOfDirectory(at: blogsDirectory, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])

        var blogs = [Blogger.Blog]()

        for content in contents {
            var fileExists: ObjCBool = false
            fileManager.fileExists(atPath: content.path, isDirectory: &fileExists)
            guard fileExists.boolValue else {
                continue
            }

            let feedURL = content.appendingPathComponent("feed").appendingPathExtension("atom")
            guard fileManager.fileExists(atPath: feedURL.path) else {
                continue
            }

            blogs.append(try BlogDecoder().decode(feedURL))
        }

        let blogger = Blogger(blogs: blogs)
        return blogger
    }
}

extension BloggerDecoder {
    struct BlogDecoder {
        private var xmlDecoder: XMLDecoder {
            let decoder = XMLDecoder()
            decoder.dateDecodingStrategy = .customISO8601
            decoder.shouldProcessNamespaces = true
            return decoder
        }

        func decode(_ atom: URL) throws -> Blogger.Blog {
            let data = try Data(contentsOf: atom)

            return try xmlDecoder.decode(Blogger.Blog.self, from: data)
        }
    }
}
