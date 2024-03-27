//
//  Optional.swift
//  FinalProject
//
//  Created by Dung Nguyen T.T. [3] VN.Danang on 7/27/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

extension Optional {

    func unwrapped(or defaultValue: Wrapped) -> Wrapped {
        return self ?? defaultValue
    }
}
