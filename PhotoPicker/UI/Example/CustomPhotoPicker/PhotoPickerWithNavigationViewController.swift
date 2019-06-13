//
//  PhotoPickerWithNavigationViewController.swift
//  PhotoPicker
//
//  Created by archer.chen on 6/13/19.
//  Copyright © 2019 CA. All rights reserved.
//

import Foundation
import UIKit

class PhotoPickerWithNavigationViewController: AWPhotosPickerViewController {
    override func makeUI() {
        super.makeUI()
        self.customNavItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .stop, target: nil, action: #selector(customAction))
    }
    @objc func customAction() {
        self.delegate?.photoPickerDidCancel()
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.dismissComplete()
            self?.dismissCompletion?()
        }
    }
    
    override func doneButtonTap() {
        let imagePreviewVC = ImagePreviewViewController()
        imagePreviewVC.assets = self.selectedAssets.first
        self.navigationController?.pushViewController(imagePreviewVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.navigationController?.topViewController is ImagePreviewViewController {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}
