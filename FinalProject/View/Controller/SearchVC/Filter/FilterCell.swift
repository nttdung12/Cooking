//
//  FilterCell.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 8/19/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

protocol FilterCellDelegate: class {
    func cell(_ cell: FilterCell, needPerformAction action: FilterCell.Action)
}

final class FilterCell: UITableViewCell {

    enum Action {
        case getKeywordSearch(keyword: String)
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Properties
    var viewModel = FilterViewModel()
    weak var delegate: FilterCellDelegate?

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configCollection()
    }

    // MARK: - Private functions
    private func configCollection() {
        collectionView.register(FilterByNameCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource
extension FilterCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(FilterByNameCell.self, forIndexPath: indexPath)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FilterCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cell(self, needPerformAction: .getKeywordSearch(keyword: viewModel.getKeyWord(at: indexPath)))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FilterCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthItem: CGFloat = viewModel.keywordSearch[indexPath.row].widthOfString(usingFont: UIFont.systemFont(ofSize: Config.fontSize)) + Config.distance
        return CGSize(width: widthItem, height: Config.heightForItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Config.minimumLineSpacingForSectionAt
    }
}

// MARK: - WidthOfString
extension String {

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

// MARK: - Config
extension FilterCell {

    struct Config {
        static let heightForItem: CGFloat = 40
        static let minimumLineSpacingForSectionAt: CGFloat = 15
        static let fontSize: CGFloat = 17
        static let distance: CGFloat = 40
    }
}
