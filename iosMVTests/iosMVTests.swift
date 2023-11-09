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

    @MainActor func testPokemonModel() throws {
        var model = PokemonColorsViewModel()
        let exp1 = expectation(description: "task finished")
        let exp2 = model.on(\.inspect) { view in
            XCTAssertNil(try view.actualView().pokemonColors.value)
            Task {
                defer { exp1.fulfill() }
                try await view.actualView().loadAsync()
                XCTAssertEqual(try view.actualView().pokemonColors.value?.count, 1)
            }
        }
        autoreleasepool {
            ViewHosting.host(
                view: model.environment(\.pokemonData, PokemonPreviewData())
            )
        }
        wait(for: [exp1, exp2], timeout: 0.1)
    }

    @MainActor func testTimer() throws {
        var sut = TimerWrapper(interval: 1, limit: 3)

        let exp1 = sut.on(\.inspect) { view in
            XCTAssertEqual(try view.actualView().elapsedTime, 0)
            try view.actualView().start()
            XCTAssertEqual(try view.actualView().elapsedTime, 1)
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
