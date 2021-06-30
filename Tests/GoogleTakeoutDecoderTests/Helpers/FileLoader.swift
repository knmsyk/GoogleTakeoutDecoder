//
//  Copyright © 2021 msyl. All rights reserved.
//

import Foundation

struct FileLoader {
    func url(_ file: File) -> URL? {
        Bundle.module.url(forResource: file.name, withExtension: file.ext)
    }

    func load(_ file: File) throws -> Data {
        try Data(contentsOf: url(file)!)
    }
}

extension FileLoader {
    enum File {
        case zip(Zip)
        case atom(Atom)
        case directory(String)

        var name: String {
            switch self {
            case .zip(let zip):
                return zip.rawValue
            case .atom(let atom):
                return atom.rawValue
            case .directory(let name):
                return name
            }
        }

        var ext: String {
            switch self {
            case .zip:
                return "zip"
            case .atom:
                return "atom"
            case .directory:
                return ""
            }
        }
    }

    enum Zip: String {
        case takeout
    }

    enum Atom: String {
        case feed = "Takeout/Blogger/Blogs/Test/feed"
    }
}
