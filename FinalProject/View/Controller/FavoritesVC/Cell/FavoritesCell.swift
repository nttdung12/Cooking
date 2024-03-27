//
//  RevoritesCell.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 8/8/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class FavoritesCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var mealImageView: UIImageView!
    @IBOutlet private weak var nameMealLabel: UILabel!
    @IBOutlet private weak var areaLabel: UILabel!
    @IBOutlet private weak var favoritesButton: UIButton!

    // MARK: - Properties
    var viewModel: FavoritesCellViewModel? {
        didSet {
            updateCell()
        }
    }

    // MARK: - Private functions
    private func updateCell() {
        guard let viewModel = viewModel else { return }
        let urlString = viewModel.meal.thumb.unwrapped(or: "")
        mealImageView.downloadImage(url: urlString) { (image) in
            self.mealImageView.image = image
        }
        nameMealLabel.text = viewModel.meal.name
        areaLabel.text = viewModel.meal.area
        favoritesButton.isHidden = viewModel.isHideFavoritesButton
    }
}
