//
//  CustomBlackStylePickerViewController.swift
//  PhotoPicker
//
//  Created by archer.chen on 6/13/19.
//  Copyright © 2019 CA. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    public func colorMask(color:UIColor) -> UIImage {
        var result: UIImage?
        let rect = CGRect(x:0, y:0, width:size.width, height:size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
        if let c = UIGraphicsGetCurrentContext() {
            self.draw(in: rect)
            c.setFillColor(color.cgColor)
            c.setBlendMode(.sourceAtop)
            c.fill(rect)
            result = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return result ?? self
    }
}

class CustomBlackStylePickerViewController: AWPhotosPickerViewController {
    override func makeUI() {
        super.makeUI()
        self.customNavItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .stop, target: nil, action: #selector(customAction))
        self.view.backgroundColor = UIColor.black
        self.collectionView.backgroundColor = UIColor.black
        self.navigationBar.barStyle = .black
        self.titleLabel.textColor = .white
        self.subTitleLabel.textColor = .white
        self.navigationBar.tintColor = .white
        self.popArrowImageView.image = UIImage(named: "Icon-Pop-Arrow")?.colorMask(color: .black)
        self.albumPopView.popupView.backgroundColor = .black
        self.albumPopView.tableView.backgroundColor = .black
    }
    
    @objc func customAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! AWCollectionTableViewCell
        cell.backgroundColor = .black
        cell.titleLabel.textColor = .white
        cell.subTitleLabel.textColor = .white
        cell.tintColor = .white
        return cell
    }
}
