//
//  RssService.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 02/07/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import Foundation
import Alamofire

public enum NetworkRequestError: Error {
    case noData
    case incorrectResponse
    case undecodable
}

public protocol NetworkRequest {
    func get<DataType: Decodable>(
        _ url: URL,
        completion: @escaping (Result<DataType, Error>) -> Void
    )
}

class AlamofireNetworkRequest: NetworkRequest {
    /// request service
    func get<RecipeData: Decodable>(
        _ url: URL,
        completion: @escaping (Result<RecipeData, Error>) -> Void
    ) {
        Alamofire.AF.request(
            url
        ).responseJSON { responseData in
            guard let data = responseData.data,
                responseData.response?.statusCode == 200,
                let responseJSON = try? JSONDecoder().decode(RecipeData.self, from: data)
                else {
                    completion(.failure(NetworkRequestError.incorrectResponse))
                    return
            }
            completion(.success(responseJSON))
        }
    }
}
