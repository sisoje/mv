import SwiftUI
import Combine

final class NiceViewModel: ObservableObject {
  @Published private var counter = 0
  private func inc() { counter += 1 }
  var body: some View {
      Button("Inc: \(counter)", action: inc)
  }
}

struct NiceView: View {
  @StateObject private var vm = NiceViewModel()
  var body: some View {
    vm.body
  }
}

class StateLogicViewmodel: ObservableObject {
    @Published var age = 21
    func makeBirthdayParty() { age += 1 }
}

extension StateLogicViewmodel {
    var body: some View { Button("My \(age + 1). bithday party", action: makeBirthdayParty) }
}

@main
struct iosMVApp: App {
    @Environment(\.scenePhase) var scenePhase

    init() {
        if Env.isDebug { // only for UI testing
            if let fileName = AppLaunchConfig.environmentDic[.replayResponsesFileName] {
                URLProtocol.registerClass(MockURLProtocol.self)
                try! MockURLProtocol.loadResponses(file: fileName)
            }
            if let file = AppLaunchConfig.environmentDic[.recordResponsesFileName] {
                InterceptURLProtocol.file = file
                URLProtocol.registerClass(InterceptURLProtocol.self)
            }
            if AppLaunchConfig.argumentSet.contains(.disableAnimations) {
                UIView.setAnimationsEnabled(false)
            }
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
            if Env.isDebug { // only for UI testing
                if
                    scenePhase == .inactive,
                    let fileName = AppLaunchConfig.environmentDic[.recordResponsesFileName]
                {
                    try! InterceptURLProtocol.saveResponses()
                }
            }
        }
    }
}
