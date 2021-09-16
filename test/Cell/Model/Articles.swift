//
//  Articles.swift
//  test
//
//  Created by Лиана Чуприна on 26.08.2021.
//

import Foundation

struct ArticlesRespose: Codable {
    let results: [ArticleResponse]
}

struct ArticleResponse: Codable {
    let url: String
    let title: String
    let updated: String
    let abstract: String
    let media: [Media]
    let id: Int
    
    var time: Date? {
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-mm-dd hh:mm:ss"
        return df.date(from: updated)
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
