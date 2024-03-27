//
//  SearchViewModel.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 8/15/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import RealmSwift

final class SearchViewModel {

    enum TypeSection: Int, CaseIterable {
        case sectionFilter = 0
        case sectionHistory
    }

    // MARK: - Properties
    private(set) var filteredMeals: [Meal] = []
    private(set) var notificationToken: NotificationToken?
    var searching: Bool = false
    var keyword: String = ""
    var history: [HistorySearch] = []

    func numberOfSections() -> Int {
        if searching {
            return 1
        } else {
            return TypeSection.allCases.count
        }
    }

    // MARK: - Public functions
    func numberOfRowsInSection(in section: Int) -> Int {
        if searching {
            return filteredMeals.count
        } else {
            guard let section = TypeSection(rawValue: section) else {
                return 0
            }
            switch section {
            case .sectionFilter:
                return 1
            case .sectionHistory:
                return history.count
            }
        }
    }

    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        if searching {
            return Config.heightForRow
        } else {
            guard let section = TypeSection(rawValue: indexPath.section) else {
                return 0
            }
            switch section {
            case .sectionFilter:
                return Config.heightForFilterRow
            case .sectionHistory:
                return Config.heightForHistory
            }
        }
    }

    func getMeals(completion: @escaping APICompletion) {
        SearchService.getMeal(keyword: keyword) { [weak self] result in
            guard let this = self else {
                completion(.failure(Api.Error.unexpectIssued))
                return
            }
            switch result {
            case .success(let filteredMeals):
                this.filteredMeals = filteredMeals
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func resetMeal() {
        filteredMeals.removeAll()
    }

    func viewModelForCell(at indexPath: IndexPath) -> FavoritesCellViewModel {
        return FavoritesCellViewModel(meal: filteredMeals[indexPath.row], isHideFavoritesButton: true)
    }

    func getHistory(at indexPath: IndexPath) -> HistorySearchCellViewModel {
        return HistorySearchCellViewModel(keywordSearch: history[indexPath.row])
    }

    func setupObserve(completion: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()
            notificationToken = realm.objects(HistorySearch.self).observe({ _ in
                self.fetchData { (done) in
                    if done {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            })
        } catch {
            completion(false)
        }
    }

    func fetchData(completion: (Bool) -> Void) {
        do {
            let realm = try Realm()
            let results = realm.objects(HistorySearch.self)
            history = Array(results)
            completion(true)
        } catch {
            completion(false)
        }
    }

    func checkIsHistorySearch() -> Bool {
        do {
            let realm = try Realm()
            let results = realm.objects(HistorySearch.self).first(where: { $0.keyword == keyword })
            return results != nil
        } catch {
            return false
        }
    }

    func saveHistorySearch(completion: @escaping APICompletion) {
        do {
            let realm = try Realm()
            try realm.write {
                let historySearch = HistorySearch()
                historySearch.keyword = keyword
                realm.add(historySearch)
                completion(.success)
            }
        } catch {
            completion(.failure(error))
        }
    }

    func deleteHistorySearch(key: String, completion: @escaping APICompletion) {
        do {
            let realm = try Realm()
            guard let results = realm.objects(HistorySearch.self).first(where: { $0.keyword == key }) else { return }
            try realm.write {
                realm.delete(results)
                completion(.success)
            }
        } catch {
            completion(.failure(error))
        }
    }
}

// MARK: - Config
extension SearchViewModel {

    struct Config {
        static let heightForRow: CGFloat = 80
        static let heightForFilterRow: CGFloat = 200
        static let heightForHistory: CGFloat = 50
    }
}
