//
//  CategoriesCellViewModel.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 7/25/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class CategoriesCellViewModel {

    // MARK: - Properties
    private var categories: [Categories] = []

    init(categories: [Categories]) {
        self.categories = categories
    }

    // MARK: - Functions
    func numberOfItemsInSection() -> Int {
        return categories.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> CategotyCellViewModel {
        return CategotyCellViewModel(item: categories[indexPath.row])
    }

    func getNameCategory(at indexPath: IndexPath) -> String {
        return categories[indexPath.row].name.unwrapped(or: "")
    }
}
