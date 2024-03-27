//
//  File.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 8/5/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class IngredientViewModel {

    // MARK: - Properties
    private(set) var ingredient: String
    private(set) var measure: String

    init(ingredient: String, measure: String) {
        self.ingredient = ingredient
        self.measure = measure
    }
}
