import Foundation
import SwiftUI

enum ImageInteractor {
    static var getImage: (URL) -> (() async throws -> Image) = { url in { try await BackendApi.shared.getImage(url: url) } }
}
