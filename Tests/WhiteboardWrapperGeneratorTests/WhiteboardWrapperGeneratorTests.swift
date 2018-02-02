import XCTest
@testable import Parsers
@testable import ParserFuncs
@testable import FileGenerators
@testable import DataStructures
@testable import WhiteboardWrapperGeneratorLib

class WhiteboardWrapperGeneratorTests: XCTestCase {
    func testContainer() {
        let name = "testContainer"
        let container = ParserObjectContainer<TSL>(location: name)
        XCTAssertEqual(container.currentLocation, name)
        XCTAssertNil(container.error)
        XCTAssertTrue(container.warnings.isEmpty)
        XCTAssertNotNil(container.object)
    }

    func testParseFail() {
        let cfg = Config()
        let fail = TSLEntryParser.parse(inputLine: "Hello", config: cfg)
        XCTAssertNil(fail.object)
        XCTAssertNotNil(fail.error)
    }

    func testParseClass() {
        let cfg = Config()
        let t = TSLEntryParser.parse(inputLine: "class:Foo, nonatomic, MessageName, Comment should be reasonable", config: cfg)
        XCTAssertNotNil(t.object)
        XCTAssertNil(t.error)
        XCTAssertTrue(t.warnings.isEmpty)
        XCTAssertEqual(t.object?.atomic.value, false)
        XCTAssertEqual(t.object?.type.typeName, "Foo")
        XCTAssertEqual(t.object?.type.isLegacyCPlusPlusClassNaming, true)
        XCTAssertEqual(t.object?.type.isCustomTypeClass, true)
    }

    func testParseType() {
        let cfg = Config()
        let t = TSLEntryParser.parse(inputLine: "type:Foo, nonatomic, MessageName, Comment should be reasonable", config: cfg)
        XCTAssertNotNil(t.object)
        XCTAssertNil(t.error)
        XCTAssertTrue(t.warnings.isEmpty)
        XCTAssertEqual(t.object?.atomic.value, false)
        XCTAssertEqual(t.object?.type.typeName, "Foo")
        XCTAssertEqual(t.object?.type.isLegacyCPlusPlusClassNaming, false)
        XCTAssertEqual(t.object?.type.isCustomTypeClass, true)
    }

    func testParseVector() {
        let cfg = Config()
        let t = TSLEntryParser.parse(inputLine: "std::vector<int>, nonatomic, MessageName, Comment should be reasonable", config: cfg)
        XCTAssertNotNil(t.object)
        XCTAssertNil(t.error)
        XCTAssertTrue(t.warnings.isEmpty)
        XCTAssertEqual(t.object?.atomic.value, false)
        XCTAssertEqual(t.object?.type.typeName, "std::vector<int>")
        XCTAssertEqual(t.object?.type.isLegacyCPlusPlusClassNaming, false)
        XCTAssertEqual(t.object?.type.isCustomTypeClass, false)
    }

    func testParseWarn() {
        let cfg = Config()
        let t = TSLEntryParser.parse(inputLine: "uint64_t, nonatomic, MessageName, Short", config: cfg)
        XCTAssertNotNil(t.object)
        XCTAssertNil(t.error)
        XCTAssertEqual(t.warnings.count, 1)
        XCTAssertEqual(t.object?.atomic.value, false)
        XCTAssertEqual(t.object?.type.typeName, "uint64_t")
        XCTAssertEqual(t.object?.type.isLegacyCPlusPlusClassNaming, false)
        XCTAssertEqual(t.object?.type.isCustomTypeClass, false)
    }

    func testParseAtomic() {
        let cfg = Config()
        let t = TSLEntryParser.parse(inputLine: "int8_t, atomic, MessageName, Comment should be reasonable", config: cfg)
        XCTAssertNotNil(t.object)
        XCTAssertNil(t.error)
        XCTAssertTrue(t.warnings.isEmpty)
        XCTAssertEqual(t.object?.atomic.value, true)
        XCTAssertEqual(t.object?.type.typeName, "int8_t")
        XCTAssertEqual(t.object?.type.isLegacyCPlusPlusClassNaming, false)
        XCTAssertEqual(t.object?.type.isCustomTypeClass, false)
    }



    static var allTests = [
        ("testParseAtomic", testParseAtomic),
        ("testContainer",   testContainer),
        ("testParseClass",  testParseClass),
        ("testParseFail",   testParseFail),
        ("testParseType",   testParseType),
        ("testParseVector", testParseVector),
    ]
}
