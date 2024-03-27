//
//  App.swift
//  FinalProject
//
//  Created by Bien Le Q. on 8/26/19.
//  Copyright © 2019 Asiantech. All rights reserved.
//

import Foundation
import Alamofire

final class Api {

    struct CategoryPath: URLStringConvertible {
        let name: String

        init(name: String) {
            self.name = name
        }

        var urlString: String {
            return Path.filterPath + name
        }
    }

    struct MealPath: URLStringConvertible {

        let id: String
        var urlString: String {
            return Path.lookupPath + id
        }

        init(id: String) {
            self.id = id
        }
    }

    struct SearchByNamePath: URLStringConvertible {

        let keyword: String
        var urlString: String {
            return Path.searchPath + keyword
        }

        init(keyword: String) {
            self.keyword = keyword
        }
    }

    struct Path {
        static let baseURL = "https://www.themealdb.com/api/json/v1/1/"
        static let categoriesPath = baseURL + "categories.php"
        static let filterPath = baseURL + "filter.php?c="
        static let searchPath = baseURL + "search.php?s="
        static let lookupPath = baseURL + "lookup.php?i="
    }
}

protocol URLStringConvertible {
    var urlString: String { get }
}

protocol ApiPath: URLStringConvertible {
    static var path: String { get }
}

private func / (lhs: URLStringConvertible, rhs: URLStringConvertible) -> String {
    return lhs.urlString + "/" + rhs.urlString
}

extension String: URLStringConvertible {
    var urlString: String { return self }
}

private func / (left: String, right: Int) -> String {
    return left.appending(path: "\(right)")
}
