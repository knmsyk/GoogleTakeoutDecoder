//
//  Copyright © 2021 msyl. All rights reserved.
//

import Foundation

struct FileLoader {
    func url(_ file: File) -> URL? {
        Bundle.module.url(forResource: file.name, withExtension: file.ext)
    }
}

extension FileLoader {
    enum File {
        case zip(Zip)

        var name: String {
            switch self {
            case .zip(let zip):
                return zip.rawValue
            }
        }

        var ext: String {
            switch self {
            case .zip:
                return "zip"
            }
        }
    }

    enum Zip: String {
        case takeout = "Takeout"
    }
}
