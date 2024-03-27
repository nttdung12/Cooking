//
//  HistorySearchCellViewModel.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 8/22/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class HistorySearchCellViewModel {

    // MARK: - Properties
    private(set) var keywordSearch: HistorySearch

    init(keywordSearch: HistorySearch) {
        self.keywordSearch = keywordSearch
    }
}
