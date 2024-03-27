//
//  SearchService.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 8/15/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import ObjectMapper

class SearchService {

    // MARK: - Public functions
    static func getMeal(keyword: String, completion: @escaping Completion<[Meal]>) {
        let urlString = Api.SearchByNamePath(keyword: keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        api.request(method: .get, urlString: urlString) { result in
            switch result {
            case . success(let data):
                if let data = data as? JSObject, let items = data["meals"] as? JSArray {
                    var meal: [Meal] = []
                    meal = Mapper<Meal>().mapArray(JSONArray: items)
                    completion(.success(meal))
                } else {
                    completion(.success([]))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
