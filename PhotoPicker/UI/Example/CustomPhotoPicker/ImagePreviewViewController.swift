//
//  ImagePreviewViewController.swift
//  PhotoPicker
//
//  Created by archer.chen on 6/13/19.
//  Copyright © 2019 CA. All rights reserved.
//

import Foundation
import UIKit

class ImagePreviewViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var assets: AWPHAsset? = nil
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: "ImagePreviewViewController", bundle: Bundle.main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = self.assets?.fullResolutionImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
