//
//  AWPhotosPicker+Extension.swift
//  PhotoPicker
//
//  Created by archer.chen on 6/13/19.
//  Copyright © 2019 CA. All rights reserved.
//

import Foundation
import UIKit

extension AWPhotosPickerViewController {
    class func custom(withAWPHAssets: (([AWPHAsset]) -> Void)? = nil, didCancel: (() -> Void)? = nil) -> CustomPhotoPickerViewController {
        let picker = CustomPhotoPickerViewController(withAWPHAssets: withAWPHAssets, didCancel:didCancel)
        return picker
    }
    
    func wrapNavigationControllerWithoutBar() -> UINavigationController {
        let navController = UINavigationController(rootViewController: self)
        navController.navigationBar.isHidden = true
        return navController
    }
}
