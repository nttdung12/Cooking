//
//  DetailRecipesViewModel.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 8/2/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import RealmSwift

final class DetailRecipeViewModel {

    // MARK: - Properties
    private(set) var detailMeal: Meal?
    private(set) var id: String

    init(id: String) {
        self.id = id
    }

    // MARK: - Public functions
    func getDetailMeals(completion: @escaping APICompletion) {
        DetailMealService.getDetailMeal(id: id) { [weak self] result in
            guard let this = self else {
                completion(.failure(Api.Error.unexpectIssued))
                return
            }
            switch result {
            case .success(let detailMeal):
                this.detailMeal = detailMeal
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func viewModelForItem(at index: Int) -> IngredientViewModel {
        return IngredientViewModel(ingredient: detailMeal?.ingredient[index] ?? "", measure: detailMeal?.measure[index] ?? "")
    }

    func checkIsFavotire() -> Bool {
        do {
            let realm = try Realm()
            let results = realm.objects(Meal.self).first(where: { $0.id == id })
            return results != nil
        } catch {
            return false
        }
    }

    func addFavorites(completion: @escaping APICompletion) {
        do {
            let realm = try Realm()
            try realm.write {
                let detailMeal = Meal()
                detailMeal.id = self.detailMeal?.id
                detailMeal.name = self.detailMeal?.name
                detailMeal.thumb = self.detailMeal?.thumb
                detailMeal.area = self.detailMeal?.area
                detailMeal.date = Date()
                realm.add(detailMeal)
                completion(.success)
            }
        } catch {
            completion(.failure(error))
        }
    }

    func deleteFavorites(completion: @escaping APICompletion) {
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
