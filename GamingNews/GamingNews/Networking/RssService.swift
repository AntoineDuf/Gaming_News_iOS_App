//
//  RssService.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 02/07/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireRSSParser

public enum NetworkRequestError: Error {
    case noData
    case incorrectResponse
    case undecodable
}

public protocol NetworkRequest {
    
    func get(
        _ url: URL,
        completion: @escaping ([RSSItem]) -> Void
    )
}

final class AlamofireNetworkRequest: NetworkRequest {
    /// request service
    func get(
        _ url: URL,
        completion: @escaping ([RSSItem]) -> Void
    ) {
        AF.request(url).responseRSS() { (response) -> Void in
            guard let feed: RSSFeed = response.value else {
                print("erreur")
                return
            }
            let feeds = feed.items
            completion(feeds)
        }
    }
}

