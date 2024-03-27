//
//  FavoritesViewController.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 8/2/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit
import RealmSwift

final class FavoritesViewController: ViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel = FavoritesViewModel()

    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Config
    override func setupUI() {
        title = "Favorite"
        tableView.register(FavoritesCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }

    override func setupData() {
        setupObserve()
    }

    // MARK: - Private functions
    private func setupObserve() {
        viewModel.setupObserve { [weak self] done in
            guard let this = self else { return }
            DispatchQueue.main.async {
                if done {
                    this.tableView.reloadData()
                } else {
                    this.alert(msg: "Error setup observe", handler: nil)
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FavoritesCell.self)
        cell.viewModel = viewModel.viewModelForCell(at: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteMealInRealm(id: viewModel.detailMeals[indexPath.row].id.unwrapped(or: "")) { [weak self] result in
                guard let this = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        this.viewModel.detailMeals.remove(at: indexPath.row)
                        this.tableView.deleteRows(at: [indexPath], with: .fade)
                    case .failure(let error):
                        this.alert(msg: error.localizedDescription, handler: nil)
                    }
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.heightForRow
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailRecipeVC = DetailRecipeViewController()
        detailRecipeVC.viewModel = DetailRecipeViewModel(id: viewModel.detailMeals[indexPath.row].id.unwrapped(or: ""))
        navigationController?.pushViewController(detailRecipeVC, animated: true)
    }
}

extension FavoritesViewController {

    struct Config {
        static let heightForRow: CGFloat = 80
    }
}
