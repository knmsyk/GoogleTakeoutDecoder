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
        public let updated: Date?
        public let filename: String?
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

extension Blogger.Blog.Entry {
    enum CodingKeys: String, CodingKey {
        case id, type, status, author, title, content, created, updated, filename
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            id: container.decode(String.self, forKey: .id),
            type: container.decode(String.self, forKey: .type),
            status: container.decode(String.self, forKey: .status),
            author: container.decode(Author.self, forKey: .author),
            title: container.decode(String.self, forKey: .title),
            content: container.decode(Content.self, forKey: .content),
            created: container.decodeDate(key: .created),
            updated: container.decodeDate(key: .updated),
            filename: try? container.decode(String.self, forKey: .filename)
        )
    }
}

extension KeyedDecodingContainer where K == Blogger.Blog.Entry.CodingKeys {
    func decodeDate(key: K) throws -> Date? {
        var rawDate = try decode(String.self, forKey: key)
        rawDate = rawDate.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        return ISO8601DateFormatter().date(from: rawDate)
    }
}
