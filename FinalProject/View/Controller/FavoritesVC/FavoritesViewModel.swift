//
//  FavoritesViewModel.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 8/8/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import RealmSwift

final class FavoritesViewModel {

    // MARK: - Properties
    var detailMeals: [Meal] = []
    private(set) var notificationToken: NotificationToken?

    // MARK: - Public functions
    func numberOfRowsInSection() -> Int {
        return detailMeals.count
    }

    func setupObserve(completion: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()
            notificationToken = realm.objects(Meal.self).observe({ _ in
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
            let results = realm.objects(Meal.self).sorted(byKeyPath: "date", ascending: true)
            detailMeals = Array(results)
            completion(true)
        } catch {
            completion(false)
        }
    }

    func viewModelForCell(at indexPath: IndexPath) -> FavoritesCellViewModel {
        return FavoritesCellViewModel(meal: detailMeals[indexPath.row])
    }

    func deleteMealInRealm(id: String, completion: @escaping APICompletion) {
        do {
            let realm = try Realm()
            guard let results = realm.objects(Meal.self).first(where: { $0.id == id }) else { return }
            try realm.write {
                realm.delete(results)
                completion(.success)
            }
        } catch {
            completion(.failure(error))
        }
    }
}
