import SwiftUI

struct ImageLoadingView: View {
    let url: URL
    @State private var sideEffect = SideEffect<Image>()

    private var image: Image {
        switch sideEffect.state {
        case .loading:
            return Image(systemName: "icloud.and.arrow.down")
        case .idle:
            return sideEffect.value ?? Image(systemName: "questionmark")
        }
    }
    
    var body: some View {
        Group {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 64)
        }
        .onAppear {
            if sideEffect.value == nil && sideEffect.state.isIdle {
                $sideEffect.loadSideEffect(ImageInteractor.getImage(url))
            }
        }
    }
}

struct ImageLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ImageLoadingView(url: URL(fileURLWithPath: ""))
    }
}
