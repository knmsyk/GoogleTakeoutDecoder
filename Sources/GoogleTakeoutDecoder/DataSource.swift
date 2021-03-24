//
//  Copyright © 2021 msyk. All rights reserved.
//

import Foundation

public enum DataSource: CaseIterable {
    case blogger
}

extension DataSource {
    var directoryPath: String {
        switch self {
        case .blogger:
            return "Blogger/Blogs"
        }
    }
}
