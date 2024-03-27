//
//  HomeViewController.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 7/22/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class HomeViewController: ViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var searchBar: UISearchBar!

    // MARK: - Properties
    var viewModel: HomeViewModel?
    private let maxHeaderHeight: CGFloat = Config.maxHeaderHeight
    private let minHeaderHeight: CGFloat = Config.minHeaderHeight
    private var previousScrollOffset: CGFloat = Config.previousScrollOffset

    // MARK: - Life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
        headerHeightConstraint.constant = maxHeaderHeight
        self.updateHeader()
    }

    // MARK: - Config
    override func setupUI() {
        tableView.register(CategoriesCell.self)
        tableView.register(CategoryRecipesCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        let text = "Make your own food, \nstay at home"
        let attributedText = text.setColor(.systemYellow, ofSubstring: "home")
        titleLabel.attributedText = attributedText
    }

    override func setupData() {
        getCategory()
    }

    // MARK: - Private functions
    private func getCategory() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.getCategory(completion: { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.getFilterByCategories()
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        })
    }

    private func getFilterByCategories(name: String = "") {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.getFilterByCategories(name: name) { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.tableView.reloadData()
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    // Customize animate header
    private func setScrollPosition(_ position: CGFloat) {
        tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: position)
    }

    private func scrollViewDidStopScrolling() {
        let range = maxHeaderHeight - minHeaderHeight
        let midPoint = minHeaderHeight + range / 2

        if headerHeightConstraint.constant > midPoint {
            expandHeader()
        } else {
            collapseHeader()
        }
    }

    private func collapseHeader() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }

    private func expandHeader() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }

    private func updateHeader() {
        let range = maxHeaderHeight - minHeaderHeight
        let openAmount = headerHeightConstraint.constant - minHeaderHeight
        let percentage = openAmount / range
        titleLabel.alpha = percentage
        searchBar.alpha = percentage
    }

    // MARK: - IBActions
    @IBAction private func searchBarTouchUpInside(_ sender: Button) {
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = HomeViewModel.RowType(rawValue: indexPath.row), let viewModel = viewModel else {
            return UITableViewCell()
        }
        switch type {
        case .categoriesCell:
            let categoriesCell = tableView.dequeue(CategoriesCell.self)
            categoriesCell.detegate = self
            categoriesCell.viewModel = viewModel.viewModelForCategories()
            return categoriesCell
        case .recipesCell:
            let recipesCell = tableView.dequeue(CategoryRecipesCell.self)
            recipesCell.viewModel = viewModel.viewModelForFilterByCategories()
            recipesCell.delegate = self
            return recipesCell
        }
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let viewModel = viewModel else {
            return 0
        }
        return CGFloat(viewModel.heightForRow(at: indexPath))
    }

    // Scrolling up and down
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollView.contentOffset.y - previousScrollOffset
        let absoluteTop: CGFloat = 0.0
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        var newHeight = headerHeightConstraint.constant
        if isScrollingDown {
            newHeight = max(minHeaderHeight, headerHeightConstraint.constant - abs(scrollDiff))
        } else if isScrollingUp {
            newHeight = min(maxHeaderHeight, headerHeightConstraint.constant + abs(scrollDiff))
        }
        if newHeight != self.headerHeightConstraint.constant {
            headerHeightConstraint.constant = newHeight
            updateHeader()
            setScrollPosition(previousScrollOffset)
        }
        previousScrollOffset = scrollView.contentOffset.y
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidStopScrolling()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidStopScrolling()
        }
    }
}

// MARK: - CategoriesCellDelegate
extension HomeViewController: CategoriesCellDelegate {

    func cell(_ cell: CategoriesCell, needPerformAction action: CategoriesCell.Action) {
        switch action {
        case .loadNewRecipes(let name):
            guard let viewModel = viewModel else { return }
            viewModel.name = name
            getFilterByCategories(name: name)
        }
    }
}

// MARK: - CategoryRecipesCellDelegate
extension HomeViewController: CategoryRecipesCellDelegate {

    func cell(_ cell: CategoryRecipesCell, needPerformAction action: CategoryRecipesCell.Action) {
        switch action {
        case .loadIdMeal(let id):
            let detailRecipeVC = DetailRecipeViewController()
            detailRecipeVC.viewModel = DetailRecipeViewModel(id: id)
            navigationController?.pushViewController(detailRecipeVC, animated: true)
        }
    }
}

// MARK: - String
extension String {

    func setColor(_ color: UIColor, ofSubstring substring: String) -> NSMutableAttributedString {
        let range = (self as NSString).range(of: substring)
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        return attributedString
    }
}

extension HomeViewController {

    struct Config {
        static let maxHeaderHeight: CGFloat = 130.0
        static let minHeaderHeight: CGFloat = 0.0
        static let previousScrollOffset: CGFloat = 0.0
    }
}
