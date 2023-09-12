@testable import iosMV
import SwiftUI
import XCTest

final class iosMVTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testBoolify() throws {
        var intVal: Int? = 5
        let intBinding = Binding { intVal } set: { intVal = $0 }
        let boolBinding: Binding<Bool> = .boolify(intBinding)
        XCTAssertTrue(boolBinding.wrappedValue)
        boolBinding.wrappedValue.toggle()
        XCTAssertFalse(boolBinding.wrappedValue)
        XCTAssertNil(intVal)
    }

    func testEnvDebug() {
        XCTAssertTrue(Env.isDebug)
        XCTAssertTrue(Env.isUnitTesting)
        XCTAssertFalse(Env.isPreviews)
    }
}
