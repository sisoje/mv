//
//  iosMVApp.swift
//  iosMV
//
//  Created by Lazar Otasevic on 12.9.23..
//

import SwiftUI

@main
struct iosMVApp: App {
    @Environment(\.scenePhase) var scenePhase

    init() {
        if let fileName = AppLaunchConfig.environmentDic[.mockResponseFileName] {
            URLProtocol.registerClass(MockURLProtocol.self)
            try! MockURLProtocol.loadResponses(file: fileName)
        }
        if AppLaunchConfig.environmentDic[.recordResponseFileName] != nil {
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
        .onChange(of: scenePhase) { newPhase in
            if
                newPhase == .inactive,
                let fileName = AppLaunchConfig.environmentDic[.recordResponseFileName]
            {
                try! InterceptURLProtocol.saveResponses(file: fileName)
            }
        }
    }
}
