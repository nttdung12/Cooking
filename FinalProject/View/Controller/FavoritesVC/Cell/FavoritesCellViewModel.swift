//
//  RevoritesCellViewModel.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 8/8/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class FavoritesCellViewModel {

    // MARK: - Properties
    private(set) var meal: Meal
    private(set) var isHideFavoritesButton: Bool

    init(meal: Meal, isHideFavoritesButton: Bool = false) {
        self.meal = meal
        self.isHideFavoritesButton = isHideFavoritesButton
    }
}
