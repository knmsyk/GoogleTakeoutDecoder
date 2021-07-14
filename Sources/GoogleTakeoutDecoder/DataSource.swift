//
//  Copyright © 2021 msyk. All rights reserved.
//

import Foundation

public enum DataSource: CaseIterable {
    case search, blogger
}

extension DataSource {
    var directoryPath: String {
        switch self {
        case .search:
            return "My Activity"
        case .blogger:
            return "Blogger/Blogs"
        }
    }
}
