import SwiftUI

struct ImageLoadingView: View {
    let url: URL
    @State private var sideEffect = SideEffect<Image>()

    var body: some View {
        Group {
            let image = sideEffect.value ?? Image(systemName: "questionmark")
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
