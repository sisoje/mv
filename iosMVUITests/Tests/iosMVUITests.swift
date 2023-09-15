import XCTest

final class iosMVUITests: BaseMockedTestCase {
    func testPokemonColors() throws {
        TestUtilities.launchMocked(
            argumentSet: [.disableAnimations],
            environmentDic: [
                recordRequests ? .recordResponsesFileName : .replayResponsesFileName: #function
            ]
        )
        
        XCUIApplication().buttons["black"].tap()
        XCTAssert(XCUIApplication().staticTexts["murkrow"].waitForExistence(timeout: 1))
    }
}
