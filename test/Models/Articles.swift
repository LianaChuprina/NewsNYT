
import Foundation

struct ArticlesResponse: Codable {
    let results: [ArticleResponse]
}

struct ArticleResponse: Codable {
    let url: String
    let title: String
    let updated: String
    let abstract: String
    let media: [Media]
    let idVC: Int
    
    var time: Date? {
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyy-mm-dd hh:mm:ss"
        return dateFormat.date(from: updated)
    }

    struct Media: Codable {
        let mediaMetadata: [MediaMetadata]

        private enum CodingKeys: String, CodingKey {
            case mediaMetadata = "media-metadata"
        }
    }

    struct MediaMetadata: Codable {
        let url: String
    }
}

extension ArticleResponse {
    enum CodingKeys: String, CodingKey {
        case idVC = "id"
        case url
        case title
        case updated
        case abstract
        case media
    }
}
