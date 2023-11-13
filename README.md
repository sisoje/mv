# SwiftUI destroys all MV patterns - a demo app

### Goals achieved
- Value-type models.
- Unit testing.
- Network snapshotting UI testing.

# Apple vs MV patterns

Many tutorials lead you to believe that MVVM is the way to go in SwiftUI. This is very incorrect! Apple made SwiftUI because they wanted to eliminate MV pattern derivatives. Please dont fight with the framework. If you like MVVM just dont use SwiftUI.

### SwiftUI eliminates View completely

There is no need for the **View**Model when there is no View. Here is the proof: 

```
extension Int: View {
    var body: some View {
        Text("I am \(self)")
    }
}
```
See, there is just an Int with a protocol expension, a body, a simple function! If you look closely the body **IS** the business logic. You can not decouple business logic from this SwiftUI View because it makes no sense.

### But decoupling is good, right?

Decoupling can be good if done right and for the right reason. We dont do decoupling decoupling for fun or to make code nice. We do it for code reuse and for testing in isolation.

### Stop abusing ObservableObject

What most of devs do is they take a nice SwiftUI view and tear it apart, making view model classes using ObservableObject.

### You broke it

Please dont do this. ObservableObject is just for sharing state between unrelated views using EnvironmentObject or ObservedObject. Its not ment to be used for chopping a nice working SwiftUI view into broken pieces that dont work.

### Dependency injection

Environment and EnvironmentObject do not work inside the class. We can not inject dependencies inside a class. It works only inside the struct that is inside the view hierarchy. Also, SwiftData does not work inside the class. Because its not the way to do it.

### Pure model

Example of a SwiftUI view, that is actually just a model, a struct:
```
struct ColorsModel {
    @Environment(\.colorSource) var colorSource
    @State var colors: [PokemonColor] = []
    func fetchColors() { colors = colorSource.fetchColors() }
}
extension ColorsModel: View {
    var body: some View {
        Button("Colors: [\(colors.count)]", action: fetchColors)
    }
}
```

In order to make ColorsModel decoupled but without using class we will use DynamicProperty struct:
```
@propertyWrapper struct ColorsModel: DynamicProperty {
    @Environment(\.colorSource) private var colorSource
    @State var colors: [PokemonColor] = []
    func fetchColors() { colors = colorSource.fetchColors() }
    var wrappedValue: Self { self }
}
struct ColorsView: View {
    @ColorsModel var colorsModel
    var body: some View {
        Button("Colors: [\(colorsModel.count)]", action: colorsModel.fetchColors)
    }
}
```

Now our model will work with dependency injection as Apple intended it to work. We did not break anything.

# Loading data asynchronously

Here I demonstrate how to use simple `@State` to make a data loading Model using a simple `LoadableValue` structure:
```
struct LoadableValue<T: Sendable>: Sendable {
    var isLoading: Bool = false
    var value: T?
    var error: Error?
}
```

Then we simply reflect the state on the UI with some modifiers:
```
.overlay {
    if pokemonColors.state.isLoading {
        ProgressView()
    }
}
```

## Unit testing SwiftUI views

The only way to properly test SwiftUI views is with ViewInspector. It requires a bit of setting up. We have macro `@ViewModelify` macro in [viewmodelify-swif](https://github.com/sisoje/viewmodelify-swift) repo for that.

## Network snapshotting tests

Snapshot testing does not have to involve images. In this case we "snapshot" real network responses and save them to a file for later reproduction during testing.\\

We need to isolate tests from the network calls. We use `URLProtocol` technique. For this purpose we developed two specific protocols: `InterceptURLProtocol` and `MockURLProtocol`\\

The App "communicates" with UI testing framework using `EnvironmentKeys` and `LaunchArguments`\\

We use the same test for making snapshots and for "replaying" them in the test run. We use `EnvironmentKeys` and either provide recording file name to write responses or snapshot file name to read responses:
```
enum EnvironmentKeys: String {
    case recordResponsesFileName
    case replayResponsesFileName
}
```

When we make snapshots, after each test run, we simulate "pressing" the home button to indicate that the app needs to save network responses to the file.\\

That's how you can achieve test coverage of about 70% easily.

# Further reading

- Jim Lai: https://swift2931.medium.com/
- Azam: https://azamsharp.com/2023/02/28/building-large-scale-apps-swiftui.html
- More about SwiftUI and stuff on viewmodelift-swift repo: https://github.com/sisoje/viewmodelify-swift
