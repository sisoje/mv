//
//  TimerView.swift
//  iosMV
//
//  Created by Lazar Otasevic on 5.11.23..
//

import SwiftUI

struct TimerView: View {
    @TimerWrapper(interval: 0.125, limit: 3) var elapsedTime
    var body: some View {
        Text("Seconds elapsed: \(elapsedTime)")
            .onAppear {
                _elapsedTime.start()
            }
    }
}

#Preview {
    TimerView()
        .environment(\.timerScheduler) { _, _ in {} }
}
