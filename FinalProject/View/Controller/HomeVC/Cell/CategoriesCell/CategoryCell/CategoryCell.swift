//
//  CategorieCell.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 7/22/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class CategoryCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var categorieLabel: UILabel!
    @IBOutlet private weak var viewImage: UIView!

    // MARK: - Properties
    var viewModel: CategotyCellViewModel? {
        didSet {
            updateView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        viewImage.layer.masksToBounds = false
    }

    // MARK: - Private function
    private func updateView() {
        guard let viewModel = viewModel else { return }
        categorieLabel.text = viewModel.item.name
        let urlString = viewModel.item.thumb.unwrapped(or: "")
        imageView.downloadImage(url: urlString) { (image) in
            self.imageView.image = image
        }
    }
}
