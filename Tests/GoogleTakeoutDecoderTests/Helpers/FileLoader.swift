//
//  Copyright © 2021 msyl. All rights reserved.
//

import Foundation

final class FileLoader {
    private lazy var bundle = Bundle(for: type(of: self))

    func url(_ file: File) -> URL? {
        bundle.url(forResource: file.name, withExtension: file.ext)
    }

    func load(_ file: File) throws -> Data {
        return try Data(contentsOf: url(file)!)
    }
}

extension FileLoader {
    enum File {
        case zip(Zip)
        case atom(Atom)

        var name: String {
            switch self {
            case .zip(let zip):
                return zip.rawValue
            case .atom(let atom):
                return atom.rawValue
            }
        }

        var ext: String {
            switch self {
            case .zip:
                return "zip"
            case .atom:
                return "atom"
            }
        }
    }

    enum Zip: String {
        case test
    }

    enum Atom: String {
        case feed
    }
}
