import XCTest
@testable import GoogleTakeoutDecoder

final class GoogleTakeoutDecoderTests: XCTestCase {
    func testExtractZipFile() throws {
        let url = FileLoader().url(.zip(.test))
        XCTAssertNotNil(url)

        let extracted = try ArchiveFileExtractor().extract(filePath: .init(url!.path))
        let data = FileManager.default.contents(atPath: String(decoding: extracted))
        XCTAssertNotNil(data)
    }

    func testDecodeBlogger() {
    }

    static var allTests = [
        ("testExample", testDecodeBlogger),
    ]
}
