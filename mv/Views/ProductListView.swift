import SwiftUI

extension Product: Identifiable {}

struct ProductListView: View {
    let products: [Product]
    @State private var productClicked: Product?

    var body: some View {
        List {
            ForEach(Array(products.enumerated()), id: \.offset) { _, product in
                Button(product.title) {
                    productClicked = product
                }
                .padding()
            }
        }
        .listStyle(.plain)
        .sheet(item: $productClicked) { product in
            ProductDetailView(product: product)
        }
    }
}

struct CatListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(products: [])
    }
}
