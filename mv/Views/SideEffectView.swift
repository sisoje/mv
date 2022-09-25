import SwiftUI

struct SideEffectView<T>: View {
    let sideEffect: SideEffect<T>

    var body: some View {
        VStack {
            switch sideEffect.state {
            case .idle:
                Text("Idle...")
            case .loading:
                Text("Loading...")
            }

            if let error = sideEffect.error {
                Text("Error: \(error.localizedDescription)")
            } else {
                Text("Ok")
            }
        }
        .font(.caption)
        .foregroundColor(.green)
    }
}

struct SideEffectView_Previews: PreviewProvider {
    static var previews: some View {
        SideEffectView<Void>(sideEffect: .init())
    }
}
