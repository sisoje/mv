# SwiftUI MV - with unit and UI testing

## Goals achieved
- no reference-type view-models just value-type models
- network "snapshotting" UI tests

## MV

Many tutorials lead you to beleive that MVVM is a way to go in SwiftUI. That is most probably wrong!

Example with a view-model class - MVVM approach:
```
class ViewModelClass: ObservableObject {
    // NOTE: this will always be default value because it's outside a View
    @Environment(\.colorSource) var colorSource
    @Published var colors: [PokemonColor] = []
    func fetchColors() { colors = colorSource.fetchColors() }
}
struct JustView: View {
    @StateObject var vm = ViewModelClass()
    var body: some View {
        Button("Colors: [\(vm.colors.count)]") {
            vm.fetchColors()
        }
    }
}
```
Example with a model struct - MV approach:
```
struct ModelStruct {
    @Environment(\.colorSource) var colorSource
    @State var colors: [PokemonColor] = []
    func fetchColors() { colors = colorSource.fetchColors() }
}
extension ModelStruct: View {
    var body: some View {
        Button("Colors: [\(colors.count)]") {
            fetchColors()
        }
    }
}
```
Like the name suggests, “Model” is the model type. It conforms to View, it is used to render view, but it is NOT View! `@State` allows you to do (state change -> view update) without intermediate objects. A `@State` value type object is always preferable when viable. In this way it is very easy to pass "actions" using `.environment()` 

Next I demonstrate how to use simple `@State` to make a data loading Model using a simple `LoadableValue` structure:
```
struct LoadableValue<T: Any> {
    enum State: Equatable {
        case idle
        case loading(TaskCancellable?)
    }
    var state: State = .idle
    var value: T?
    var error: Error?
}
```

Reference-type view-models are needed only when we share data between multiple views

## Network snapshotting tests

Snapshot testing does not have to involve images. In this case we "snapshot" real network responses and save them to a file for later reproduction during testing.

We need to isolate tests from the network calls. We use `URLProtocol` technique. For this purpose we developed two specific protocols: `InterceptURLProtocol` and `MockURLProtocol`

The App "communicates" with UI testing framework using `EnvironmentKeys` and `LaunchArguments`

We use the same test for making snapshots and for "replaying" them in the test run. We use `EnvironmentKeys` and either provide recording file name to write responses or snapshot file name to read responses.
 ```
 enum EnvironmentKeys: String {
    case recordResponseFileName
    case mockResponseFileName
}
```

When we make snapshots then after each test run we simulate "press" home button to indicate that the app needs to save network responses to the file.

Thats how you get test coverage of about 70% easily without test induced design damage.

# Further reading

- Jim Lai on Medium: https://swift2931.medium.com/
- Apple forums: https://developer.apple.com/forums/thread/699003
