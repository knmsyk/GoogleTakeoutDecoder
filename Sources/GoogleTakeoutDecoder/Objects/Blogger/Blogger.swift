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
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        status = try container.decode(String.self, forKey: .status)
        author = try container.decode(Author.self, forKey: .author)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(Content.self, forKey: .content)
        filename = try? container.decode(String.self, forKey: .filename)
        created = try container.decodeDate(key: .created)
        updated = try container.decodeDate(key: .updated)
    }
}

extension KeyedDecodingContainer where K == Blogger.Blog.Entry.CodingKeys {
    func decodeDate(key: K) throws -> Date? {
        var rawDate = try decode(String.self, forKey: key)
        rawDate = rawDate.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        return ISO8601DateFormatter().date(from: rawDate)
    }
}
