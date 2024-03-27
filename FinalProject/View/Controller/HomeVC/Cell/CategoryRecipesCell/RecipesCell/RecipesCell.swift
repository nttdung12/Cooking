//
//  RecipesCell.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 7/26/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class RecipesCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    // MARK: - Properties
    var viewModel: RecipesCellViewModel? {
        didSet {
            updateCell()
        }
    }

    // MARK: - Private functions
    private func updateCell() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.item.name
        let urlString = viewModel.item.thumb.unwrapped(or: "")
        imageView.downloadImage(url: urlString) { (image) in
            self.imageView.image = image
        }
    }
}
