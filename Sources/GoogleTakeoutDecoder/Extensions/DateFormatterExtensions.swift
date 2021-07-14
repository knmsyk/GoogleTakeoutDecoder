//
//  Created by msyk on 2021/07/11.
//

import Foundation
import XMLCoder

extension DateFormatter {
    convenience init(format: String) {
        self.init()
        dateFormat = format
        locale = Locale(identifier: "en_US_POSIX")
        timeZone = TimeZone(secondsFromGMT: 0)
        calendar = Calendar(identifier: .iso8601)
    }

    static let iso8601withFractionalSeconds = DateFormatter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX")
    static let iso8601 = DateFormatter(format: "yyyy-MM-dd'T'HH:mm:ssXXXXX")
}

extension JSONDecoder.DateDecodingStrategy {
    static let customISO8601 = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        if let date = DateFormatter.iso8601withFractionalSeconds.date(from: string) ?? DateFormatter.iso8601.date(from: string) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}

extension XMLCoder.XMLDecoder.DateDecodingStrategy {
    static let customISO8601 = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        if let date = DateFormatter.iso8601withFractionalSeconds.date(from: string) ?? DateFormatter.iso8601.date(from: string) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}
