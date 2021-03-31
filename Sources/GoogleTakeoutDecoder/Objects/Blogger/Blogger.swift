//
//  Created by msyk on 2021/03/24.
//

import Foundation

import protocol XMLCoder.DynamicNodeEncoding
import class XMLCoder.XMLEncoder

public struct Blogger: Decodable {
    public var blogs: [Blog]
}

extension Blogger {
    public struct Blog: Decodable {
        public let id: String
        public let title: String
        public let entry: [Entry]
    }
}

extension Blogger.Blog {
    public struct Entry: Decodable {
        public let id: String
        public let type: String
        public let status: String
        public let author: Author
        public let title: String?
        public let content: Content?
        public let created: Date?
        public let published: Date?
        public let updated: Date?
        public let filename: String
    }
}

extension Blogger.Blog.Entry {
    public struct Author: Decodable {
        public let name: String
    }

    public struct Content: Decodable, DynamicNodeEncoding {
        public let type: String
        public let value: String

        public enum CodingKeys: String, CodingKey {
            case type
            case value = ""
        }

        public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
            switch key {
            case CodingKeys.type:
                return .attribute
            default:
                return .element
            }
        }
    }
}
