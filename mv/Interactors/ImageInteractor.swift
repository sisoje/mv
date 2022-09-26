import Foundation
import SwiftUI

enum ImageInteractor {
    static var getImage: (URL) -> (() async throws -> Image) = { url in { try await NetworkingData.shared.getImage(url: url) } }
}
