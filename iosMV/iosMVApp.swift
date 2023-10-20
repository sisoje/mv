import SwiftUI

@main
struct iosMVApp: App {
    @Environment(\.scenePhase) var scenePhase

    init() {
        if let fileName = AppLaunchConfig.environmentDic[.replayResponsesFileName] {
            URLProtocol.registerClass(MockURLProtocol.self)
            try! MockURLProtocol.loadResponses(file: fileName)
        }
        if AppLaunchConfig.environmentDic[.recordResponsesFileName] != nil {
            URLProtocol.registerClass(InterceptURLProtocol.self)
        }
        if AppLaunchConfig.argumentSet.contains(.disableAnimations) {
            UIView.setAnimationsEnabled(false)
        }
    }

    var body: some Scene {
        WindowGroup {
            if Env.isUnitTesting {
                EmptyView()
            } else {
                PokemonColorsView()
            }
        }
        .onChange(of: scenePhase) {
            if
                scenePhase == .inactive,
                let fileName = AppLaunchConfig.environmentDic[.recordResponsesFileName]
            {
                try! InterceptURLProtocol.saveResponses(file: fileName)
            }
        }
    }
}
