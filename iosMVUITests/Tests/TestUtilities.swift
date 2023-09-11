import XCTest

enum TestUtilities {
    static func pressHome() {
        XCUIDevice.shared.press(XCUIDevice.Button.home)
    }

    static func elementById(_ id: String) -> XCUIElement {
        XCUIApplication()
            .descendants(matching: .any)
            .element(matching: .any, identifier: id)
    }

    static func launchMocked(
        argumentSet: Set<LaunchArguments>,
        environmentDic: [EnvironmentKeys: String]
    ) {
        let app = XCUIApplication()
        argumentSet.forEach { key in
            app.launchArguments.append(key.rawValue)
        }
        environmentDic.forEach { key, value in
            app.launchEnvironment[key.rawValue] = value
        }
        app.launch()
    }
}
