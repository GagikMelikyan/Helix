//
//  Item.swift
//  HelixTask
//
//  Created by G.M on 12.05.21.
//

import Foundation

struct ItemData: Codable {
    let data: [Item]

    enum  CodingKeys: String, CodingKey {
        case data = "metadata"
    }
}

struct Item: Codable {
    let category: String
    let title: String
    let body: String
    let coverPhotoUrl: String
    let date: Double
    let gallery: [ItemGallery]?
    let video: [ItemVideo]?
}

struct ItemGallery: Codable {
    let title: String
    let thumbnailUrl: String
    let contentUrl: String
}

struct ItemVideo: Codable {
    let title: String
    let thumbnailUrl: String
    let youtubeId: String
}
