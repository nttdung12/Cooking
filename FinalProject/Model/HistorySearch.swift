//
//  HistorySearch.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 8/22/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import RealmSwift

final class HistorySearch: Object {

    @objc dynamic var keyword: String = ""

    override static func primaryKey() -> String? {
            return "keyword"
        }
}
