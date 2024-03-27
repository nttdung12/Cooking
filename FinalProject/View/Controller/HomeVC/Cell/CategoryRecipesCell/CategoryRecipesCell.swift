//
//  CategoryRecipesCell.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 7/26/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

protocol CategoryRecipesCellDelegate: class {
    func cell(_ cell: CategoryRecipesCell, needPerformAction action: CategoryRecipesCell.Action)
}

final class CategoryRecipesCell: UITableViewCell {

    enum Action {
        case loadIdMeal(id: String)
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var categoryLabel: UILabel!

    // MARK: - Properties
    var viewModel: CategoryRecipesCellViewModel? {
        didSet {
            updateView()
        }
    }
    weak var delegate: CategoryRecipesCellDelegate?

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configCollection()
    }

    private func updateView() {
        collectionView.reloadData(moveTop: true)
        categoryLabel.text = viewModel?.name
    }

    // MARK: - Private functions
    private func configCollection() {
        collectionView.register(RecipesCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension CategoryRecipesCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItemsInSection() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(RecipesCell.self, forIndexPath: indexPath)
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CategoryRecipesCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, needPerformAction: .loadIdMeal(id: viewModel.getIdMeal(at: indexPath)))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoryRecipesCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Config.widthOfItem, height: Config.heightOfItem)
    }
}

// MARK: - Config
extension CategoryRecipesCell {

    struct Config {
        static let widthOfItem: CGFloat = (UIScreen.main.bounds.width - 60) / 2
        static let heightOfItem: CGFloat = UIScreen.main.bounds.height / 3.5
    }
}
