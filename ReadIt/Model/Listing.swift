//
//  Listing.swift
//  ReadIt
//
//  Created by Marc Nieto on 4/10/18.
//  Copyright © 2018 Marc Nieto. All rights reserved.
//

import Foundation

struct Listing: Decodable {
    let kind: String
    let data: ListingData
}

struct ListingData: Decodable {
    let title: String
    let author: String
    let created: Date
    let thumbnail: String
    let numberOfComments: Int

    enum CodingKeys: String, CodingKey {
        case title
        case author
        case created = "created_utc"
        case thumbnail
        case numberOfComments = "num_comments"
    }
}

struct TopListingsResponse: Decodable {
    let kind: String
    let data: TopListingsResponseData
}

struct TopListingsResponseData: Decodable {
    let listings: [Listing]

    enum CodingKeys : String, CodingKey {
        case listings = "children"
    }
}
