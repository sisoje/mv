import Foundation

enum TestingFileUtilities {
    private static let prettyEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    private static func getTestingFilesDirectoryUrl(thisFile: String = #file) -> URL {
        URL(fileURLWithPath: thisFile)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("TestingFiles")
    }

    static func getTestingFileUrl(fileName: String) -> URL {
        getTestingFilesDirectoryUrl()
            .appendingPathComponent(fileName)
    }

    static func writeTestingFileData(fileName: String, data: Data) throws {
        let url = getTestingFileUrl(fileName: fileName)
        try data.write(to: url)
    }

    static func readTestingFileData(fileName: String) throws -> Data {
        let url = getTestingFileUrl(fileName: fileName)
        return try Data(contentsOf: url)
    }

    static func readDecodable<T: Decodable>(fileName: String, decoder: JSONDecoder = .init()) throws -> T {
        let data = try readTestingFileData(fileName: fileName)
        return try JSONDecoder().decode(T.self, from: data)
    }

    static func writeEncodable<T: Encodable>(fileName: String, value: T, encoder: JSONEncoder = prettyEncoder) throws {
        let data = try encoder.encode(value)
        try writeTestingFileData(fileName: fileName, data: data)
    }
}
