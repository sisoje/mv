import Foundation

enum AppLaunchConfig {
    static let environmentDic: [EnvironmentKeys: String] =
        Dictionary(uniqueKeysWithValues: ProcessInfo.processInfo.environment.compactMap { key, value in
            EnvironmentKeys(rawValue: key).map { ($0, value) }
        })

    static let argumentSet: Set<LaunchArguments> = Set(ProcessInfo.processInfo.arguments.compactMap { LaunchArguments(rawValue: $0) })
}
