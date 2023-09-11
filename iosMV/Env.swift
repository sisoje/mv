import Foundation

enum Env {
    static let isDebug: Bool = {
        var isDebug = false
        assert({
            isDebug = true
        }() == ())
        return isDebug
    }()

    static let isUnitTesting = isDebug && ProcessInfo.processInfo.environment.keys.contains("XCTestConfigurationFilePath")

    static let isPreviews = isDebug && ProcessInfo.processInfo.environment.keys.contains("XCODE_RUNNING_FOR_PREVIEWS")
}
