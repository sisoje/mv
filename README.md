# SwiftUI MV 

Many tutorials lead you to beleive that MVVM is a way to go in SwiftUI.
Well... that is most probably WRONG! Apple has never even used the term MVVM!

### MVVM is an anti-pattern in SwiftUI
### MVVM never told you about value type

In the past view model has to trigger view update somehow, (e.g.; third-party binding) so extra overhead may be justified.
In SwiftUI binding is done in the Model, which conforms to View, NOT in ViewModel which conforms to ObservableObject; so the easiest way to trigger view update is inside the Model.

Example:
```
struct Model: View {
    @State var data = "somedata"
    func doSeomthing() {
        data = "newdata" // trigger view update
    }
}
```

Like the name suggests, “Model” is the model type. It conforms to View, it is used to render view, but it is NOT View!

@State allows you to do (state change -> view update) without intermediate objects. A @State value type object is always preferable when viable.

Here I demonstrate how to use simple @State to make a data loading Model using a simple SideEffect structure:
```
struct SideEffect<T: Any> {
    enum State {
        case idle
        case loading(AnyCancellable)
    }

    var value: T?
    var error: Error?
    var state: State = .idle
}
```

And then we make a simple View:

```
struct ProductsLoadingView: View {
    @State private var sideEffet = SideEffect<[Product]>()
    var body: some View {
        VStack {            
            ProductListView(products: sideEffet.value ?? [])
        }
        .onAppear {
            $sideEffet.loadSideEffect(ProductInteractor.getProducts)
        }
    }
}
```

There you have it, pure MV in vanilla SwiftUI

# Further reading

- Jim Lai on Medium: https://swift2931.medium.com/
- Apple forums: https://developer.apple.com/forums/thread/699003
