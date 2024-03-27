//
//  FilterCategories.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 7/29/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

final class Meal: Object, Mappable {

    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var thumb: String?
    @objc dynamic var area: String?
    @objc dynamic var date: Date?
    var recipe: String?
    var video: String?
    var ingredient: [String] = []
    var measure: [String] = []

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience required init(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["idMeal"]
        name <- map["strMeal"]
        thumb <- map["strMealThumb"]
        area <- map["strArea"]
        recipe <- map["strInstructions"]
        video <- map["strYoutube"]
        for i in 1...20 {
            var item: String = ""
            item <- map["strIngredient\(i)"]
            if item != "" {
                ingredient.append(item)
            }
        }
        for j in 1...20 {
            var item: String = ""
            item <- map["strMeasure\(j)"]
            if item != "" {
                measure.append(item)
            }
        }
    }
}
