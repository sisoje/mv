//
//  AgeView.swift
//  iosMV
//
//  Created by Lazar Otasevic on 9.11.23..
//

import SwiftUI
import ViewModelify

@ViewModelify
@propertyWrapper struct AgeViewModel: DynamicProperty {
    @State private var age = 21
    var text: Text {
        Text("My age is \(age)")
    }
    func birthdayParty() {
        age += 1
    }
}

struct AgeView: View {
    @AgeViewModel var vm
    var body: some View {
        VStack {
            Button("Birthday party", action: vm.birthdayParty)
            vm.text
        }
    }
}

#Preview {
    AgeView()
}
