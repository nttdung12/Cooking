//
//  FilterByNameCell.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 8/19/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class FilterByNameCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var nameMealLabel: UILabel!

    // MARK: - Properties
    var viewModel: FilterByNameCellViewModel? {
        didSet {
            updateCell()
        }
    }

    // MARK: - Private functions
    private func updateCell() {
        guard let viewModel = viewModel else { return }
        nameMealLabel.text = viewModel.nameMeal
    }
}
