//
//  Created by msyk on 2021/07/11.
//

import Foundation

struct SearchDecoder {
    let fileManager: FileManager
    private let decoder = JSONDecoder(dateDecodingStrategy: .customISO8601)

    func decode(_ directoryPath: URL) throws -> Search {
        var activities = [Search.Activity]()

        let products = Search.Product.allCases
        for product in products {
            let productDirectory = directoryPath.appendingPathComponent(product.directoryName)
            let items = try decodeProduct(productDirectory)
            activities.append(.init(product: product, items: items.filter { $0.title.starts(with: "Searched for") }))
        }

        return Search(activities: activities)
    }

    private func decodeProduct(_ productDirectory: URL) throws -> [Search.Item] {
        var fileExists: ObjCBool = false
        fileManager.fileExists(atPath: productDirectory.path, isDirectory: &fileExists)
        guard fileExists.boolValue else {
            return []
        }

        let fileURL = productDirectory.appendingPathComponent("MyActivity").appendingPathExtension("json")
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return []
        }

        let data = try Data(contentsOf: fileURL)
        return try decoder.decode([Search.Item].self, from: data)
    }
}
