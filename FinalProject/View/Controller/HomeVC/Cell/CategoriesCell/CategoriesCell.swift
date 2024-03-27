//
//  CategoriesCell.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 7/22/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

protocol CategoriesCellDelegate: class {
    func cell(_ cell: CategoriesCell, needPerformAction action: CategoriesCell.Action)
}

final class CategoriesCell: UITableViewCell {

    enum Action {
        case loadNewRecipes(name: String)
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Properties
    var viewModel: CategoriesCellViewModel? {
        didSet {
            collectionView.reloadData()
        }
    }

    weak var detegate: CategoriesCellDelegate?

    // MARL: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }

    // MARK: - Private functions
    private func configCell() {
        collectionView.register(CategoryCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

// MARK: - UICollectionViewDataSource
extension CategoriesCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItemsInSection() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeue(CategoryCell.self, forIndexPath: indexPath)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CategoriesCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        detegate?.cell(self, needPerformAction: .loadNewRecipes(name: viewModel.getNameCategory(at: indexPath)))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoriesCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Config.widthOfItem, height: Config.heightOfItem)
    }
}

// MARK: - Config
extension CategoriesCell {

    struct Config {
        static let widthOfItem: CGFloat = (UIScreen.main.bounds.width - 20) / 5
        static let heightOfItem: CGFloat = ((UIScreen.main.bounds.width - 20) / 5) * 7 / 5
    }
}
