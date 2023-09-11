import SwiftUI

extension Binding {    
    static func boolify<T: Any>(_ binding: Binding<T?>) -> Binding<Bool> {
        Binding<Bool> {
            binding.wrappedValue != nil
        } set: { newValue in
            guard !newValue else {
                assertionFailure()
                return
            }
            binding.wrappedValue = nil
        }
    }
}
