import XCTest

class BaseMockedTestCase: XCTestCase {
    var recordRequests = false
    var shotCount = 0
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDown() async throws {
        if recordRequests {
            TestUtilities.pressHome()
        }
    }
    
    func takeShot(_ function: String = #function, _ line: Int = #line) {
        let attachment = XCTAttachment(screenshot: XCUIApplication().screenshot())
        attachment.name = "\(function)-\(line)-\(shotCount)"
        shotCount += 1
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
