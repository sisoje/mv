//
//  TimerWrapper.swift
//  iosMV
//
//  Created by Lazar Otasevic on 5.11.23..
//

import Combine
import SwiftUI
import ViewModelify

@ViewModelify
@propertyWrapper struct TimerWrapper: DynamicProperty, @unchecked Sendable {
    @Environment(\.timerScheduler) private var timerScheduler
    @State var elapsedTime: TimeInterval = 0
    @State private var invalidator: AnyCancellable?
    let interval: TimeInterval
    let limit: TimeInterval

    func start() {
        invalidator = AnyCancellable(
            timerScheduler(interval) {
                elapsedTime += interval
                if elapsedTime >= limit {
                    stop()
                }
            }
        )
    }

    func stop() {
        invalidator?.cancel()
        invalidator = nil
    }
}
