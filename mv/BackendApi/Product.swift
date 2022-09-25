import Foundation

struct Product: Decodable {
    let id: Int
    let title: String
    let description: String
    let thumbnail: URL
    let images: [URL]
}
