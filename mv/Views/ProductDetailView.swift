import SwiftUI

struct ProductDetailView: View {
    let product: Product

    var body: some View {
        NavigationView {
            List {
                ForEach(Array(product.images.enumerated()), id: \.offset) { _, url in
                    ImageLoadingView(url: url)
                }
            }
            .navigationTitle(product.title)
        }
    }
}
