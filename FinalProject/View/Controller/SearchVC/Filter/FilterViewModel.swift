//
//  FilterByNameCellViewModel.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 8/19/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class FilterViewModel {

    // MARK: - Properties
    private(set) var keywordSearch: [String] = ["Beef", "Egg", "Fish", "Salad", "Soup",
                                                "Cake", "Pie", "Lamb", "Chicken"]

    // MARK: - Public functions
    func numberOfItemsInSection() -> Int {
        return keywordSearch.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> FilterByNameCellViewModel {
        return FilterByNameCellViewModel(nameMeal: keywordSearch[indexPath.row])
    }

    func getKeyWord(at indexPath: IndexPath) -> String {
        return keywordSearch[indexPath.row]
    }
}
