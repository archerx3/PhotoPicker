//
//  AWBundle.swift
//  PhotoPicker
//
//  Created by archer.chen on 6/13/19.
//  Copyright © 2019 CA. All rights reserved.
//

import Foundation
import UIKit

open class AWBundle {
    class func mainBundle() -> Bundle {
        return Bundle.main
    }
    
    class func bundle() -> Bundle {
        let bundle = Bundle(for: AWBundle.self)
        return bundle
    }
}
