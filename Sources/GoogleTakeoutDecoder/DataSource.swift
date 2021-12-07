//
//  Copyright © 2021 msyk. All rights reserved.
//

import Foundation

public enum DataSource: CaseIterable {
    case search, blogger, locationHistory, youtube
}

extension DataSource {
    var directoryPath: String {
        switch self {
        case .search:
            return "My Activity"
        case .blogger:
            return "Blogger"
        case .locationHistory:
            return "Location History"
        case .youtube:
            return "YouTube and YouTube Music"
        }
    }
}
