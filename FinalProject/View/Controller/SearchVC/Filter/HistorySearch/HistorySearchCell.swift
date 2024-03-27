//
//  HistorySearchCell.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 8/22/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

protocol HistorySearchCellDelegate: class {
    func cell(_ cell: HistorySearchCell, needPerformAction action: HistorySearchCell.Action)
}

final class HistorySearchCell: UITableViewCell {

    // MARK: - Enum
    enum Action {
        case deleteHistory(key: String)
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var keywordLabel: UILabel!

    // MARK: - Properties
    var viewModel: HistorySearchCellViewModel? {
        didSet {
            updateCell()
        }
    }
    weak var delegate: HistorySearchCellDelegate?

    // MARK: - Private functions
    private func updateCell() {
        guard let viewModel = viewModel else { return }
        keywordLabel.text = viewModel.keywordSearch.keyword
    }

    // MARK: - IBActions
    @IBAction private func deleteButtonTouchUpInside(_ sender: UIButton) {
        delegate?.cell(self, needPerformAction: .deleteHistory(key: keywordLabel.text ?? ""))
    }
}
