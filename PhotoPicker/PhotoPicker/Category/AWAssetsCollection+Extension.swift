//
//  AWAssetsCollection+Extension.swift
//  PhotoPicker
//
//  Created by archer.chen on 6/13/19.
//  Copyright © 2019 CA. All rights reserved.
//

import Foundation
import Photos

public enum PHFetchedResultGroupedBy {
    case year
    case month
    case week
    case day
    case hour
    case custom(dateFormat: String)
    var dateFormat: String {
        switch self {
        case .year:
            return "yyyy"
        case .month:
            return "yyyyMM"
        case .week:
            return "yyyyMMW"
        case .day:
            return "yyyyMMdd"
        case .hour:
            return "yyyyMMddHH"
        case let .custom(dateFormat):
            return dateFormat
        }
    }
}

extension AWAssetsCollection {
    func enumarateFetchResult(groupedBy: PHFetchedResultGroupedBy) -> Dictionary<String,[AWPHAsset]> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = groupedBy.dateFormat
        var assets = [PHAsset]()
        assets.reserveCapacity(self.fetchResult?.count ?? 0)
        self.fetchResult?.enumerateObjects({ (phAsset, idx, stop) in
            if phAsset.creationDate != nil {
                assets.append(phAsset)
            }
        })
        let sections = Dictionary(grouping: assets.map{ AWPHAsset(asset: $0) }) { (element) -> String in
            if let creationDate = element.phAsset?.creationDate {
                let identifier = dateFormatter.string(from: creationDate)
                return identifier
            }
            return ""
        }
        return sections
    }
    
    func section(groupedBy: PHFetchedResultGroupedBy) -> [(String,[AWPHAsset])] {
        let dict = enumarateFetchResult(groupedBy: groupedBy)
        var sections = [(String,[AWPHAsset])]()
        let sortedKeys = dict.keys.sorted(by: >)
        for key in sortedKeys {
            if let array = dict[key] {
                sections.append((key, array))
            }
        }
        return sections
    }
}
