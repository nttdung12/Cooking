//
//  Categories.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 7/26/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class Categories {

    var name: String?
    var thumb: String?

    init(json: JSObject) {
        name = json["strCategory"] as? String
        thumb = json["strCategoryThumb"] as? String
    }
}
