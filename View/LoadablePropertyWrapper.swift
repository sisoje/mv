import SwiftUI

@propertyWrapper struct Loadable<T>: DynamicProperty {
    @State private var loadableValue: LoadableValue<T> = .init()
    var wrappedValue: LoadableValue<T> { loadableValue }
    var projectedValue: Binding<LoadableValue<T>> { $loadableValue }
}
