//
//  AWCollectionTableViewCell.swift
//  PhotoPicker
//
//  Created by archer.chen on 6/13/19.
//  Copyright © 2019 CA. All rights reserved.
//

import UIKit

open class AWCollectionTableViewCell: UITableViewCell {
    @IBOutlet open var thumbImageView: UIImageView!
    @IBOutlet open var titleLabel: UILabel!
    @IBOutlet open var subTitleLabel: UILabel!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 11.0, *) {
            self.thumbImageView.accessibilityIgnoresInvertColors = true
        }
    }
}
