import XCTest
@testable import GoogleTakeoutDecoder

final class GoogleTakeoutDecoderTests: XCTestCase {
    private let url = FileLoader().url(.zip(.takeout))!

    func testDecode() throws {
        let object = try GoogleTakeoutDecoder().decode(url)
        XCTAssertEqual(object.blogger?.blogs.count, 1)
    }

    func testDecodeBlogger() throws {
        let blogger = try GoogleTakeoutDecoder([.blogger]).decode(url).blogger

        let blog = blogger?.blogs.first
        XCTAssertEqual(blog?.title, "Blog Title")
        XCTAssertEqual(blog?.entry.count, 1)

        let entry = blog?.entry.first
        XCTAssertEqual(entry?.id, "tag:blogger.com,1999:blog-XXXX.post-XXXX")
        XCTAssertEqual(entry?.title, "Test Title")
        XCTAssertEqual(entry?.author.name, "K")
        XCTAssertEqual(entry?.content.value, "Test Content")
        XCTAssertEqual(entry?.content.type, "html")
        XCTAssertEqual(entry?.filename, "/2008/10/11-4-10-24-a4.html")
        XCTAssertEqual(entry?.created, Date(timeIntervalSinceReferenceDate: 0))
        XCTAssertEqual(entry?.published, Date(timeIntervalSinceReferenceDate: 0))
        XCTAssertEqual(entry?.updated, Date(timeIntervalSinceReferenceDate: 0))
    }

    static var allTests = [
        ("testDecode", testDecode),
        ("testDecodeBlogger", testDecodeBlogger),
    ]
}
