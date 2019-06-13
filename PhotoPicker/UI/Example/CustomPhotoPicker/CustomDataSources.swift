//
//  CustomDataSources.swift
//  PhotoPicker
//
//  Created by archer.chen on 6/13/19.
//  Copyright © 2019 CA. All rights reserved.
//

import Foundation
import Photos

struct CustomDataSources: AWPhotopickerDataSourcesProtocol {
    func headerReferenceSize() -> CGSize {
        return CGSize(width: 320, height: 50)
    }
    
    func footerReferenceSize() -> CGSize {
        return CGSize.zero
    }
    
    func supplementIdentifier(kind: String) -> String {
        if kind == UICollectionView.elementKindSectionHeader {
            return "CustomHeaderView"
        }else {
            return "CustomFooterView"
        }
    }
    
    func registerSupplementView(collectionView: UICollectionView) {
        let headerNib = UINib(nibName: "CustomHeaderView", bundle: Bundle.main)
        collectionView.register(headerNib,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "CustomHeaderView")
        let footerNib = UINib(nibName: "CustomFooterView", bundle: Bundle.main)
        collectionView.register(footerNib,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: "CustomFooterView")
    }
    
    func configure(supplement view: UICollectionReusableView, section: (title: String, assets: [AWPHAsset])) {
        if let reuseView = view as? CustomHeaderView {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MMM dd, yyyy"
            dateFormat.locale = Locale.current
            if let date = section.assets.first?.phAsset?.creationDate {
                reuseView.titleLabel.text = dateFormat.string(from: date)
            }
        }else if let reuseView = view as? CustomFooterView {
            reuseView.titleLabel.text = "Footer"
        }
    }
}
