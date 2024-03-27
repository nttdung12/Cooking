//
//  App.swift
//  FinalProject
//
//  Created by Bien Le Q. on 8/26/19.
//  Copyright © 2019 Asiantech. All rights reserved.
//

import UIKit
import MVVM
import Kingfisher

class ImageView: UIImageView, MVVM.View { }

extension UIImageView {

    func downloadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        kf.indicatorType = .activity
        kf.setImage(with: url)
    }
}
