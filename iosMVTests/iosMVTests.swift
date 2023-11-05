@testable import iosMV
import SwiftUI
import ViewInspector
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

    @MainActor func testTimer() throws {
        struct DummyView: View {
            @TimerWrapper(interval: 1, limit: 3) public var timeCounter
            var rawWrapper: TimerWrapper { _timeCounter }
            var didAppear: ((Self) -> Void)? // framework requriment
            var body: some View { EmptyView().onAppear { didAppear?(self) } }
        }

        var sut = DummyView()

        let exp1 = sut.on(\.didAppear) { view in
            XCTAssertEqual(try view.actualView().timeCounter, 0)
            try view.actualView().rawWrapper.start()
            XCTAssertEqual(try view.actualView().timeCounter, 1)
        }

        let exp2 = expectation(description: "timer started")
        let exp3 = expectation(description: "timer stopped")

        let viewWithEnvironment = sut.environment(\.timerScheduler) { _, block in
            exp2.fulfill()
            block()
            return {
                exp3.fulfill()
            }
        }

        autoreleasepool {
            ViewHosting.host(view: viewWithEnvironment)
        }

        wait(for: [exp1, exp2, exp3], timeout: 0.1)
    }
}
