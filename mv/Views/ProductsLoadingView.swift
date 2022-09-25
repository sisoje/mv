import SwiftUI

struct ProductsLoadingView: View {
    @State private var sideEffet = SideEffect<[Product]>()
    
    var body: some View {
        VStack {
            SideEffectView(sideEffect: sideEffet)
            
            ProductListView(products: sideEffet.value ?? [])
        }
        .onAppear {
            $sideEffet.loadSideEffect(ProductInteractor.getProducts)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsLoadingView()
    }
}
