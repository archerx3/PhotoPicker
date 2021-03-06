//
//  AWAlbumPopView.swift
//  PhotoPicker
//
//  Created by archer.chen on 6/13/19.
//  Copyright © 2019 CA. All rights reserved.
//

import Foundation
import UIKit

protocol AWPopupViewProtocol: class {
    var bgView: UIView! { get set }
    var popupView: UIView! { get set }
    var originalFrame: CGRect { get set }
    var show: Bool { get set }
    func setupPopupFrame()
}

extension AWPopupViewProtocol where Self: UIView {
    fileprivate func getFrame(scale: CGFloat) -> CGRect {
        var frame = self.originalFrame
        frame.size.width = frame.size.width * scale
        frame.size.height = frame.size.height * scale
        frame.origin.x = self.frame.width/2 - frame.width/2
        return frame
    }
    func setupPopupFrame() {
        if self.originalFrame == CGRect.zero {
            self.originalFrame = self.popupView.frame
        }else {
            self.originalFrame.size.height = self.popupView.frame.height
        }
    }
    func show(_ show: Bool, duration: TimeInterval = 0.1) {
        guard self.show != show else { return }
        self.layer.removeAllAnimations()
        self.isHidden = false
        self.popupView.frame = show ? getFrame(scale: 0.1) : self.popupView.frame
        self.bgView.alpha = show ? 0 : 1
        UIView.animate(withDuration: duration, animations: {
            self.bgView.alpha = show ? 1 : 0
            self.popupView.transform = show ? CGAffineTransform(scaleX: 1.05, y: 1.05) : CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.popupView.frame = show ? self.getFrame(scale: 1.05) : self.getFrame(scale: 0.1)
        }) { _ in
            self.isHidden = show ? false : true
            UIView.animate(withDuration: duration) {
                if show {
                    self.popupView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.popupView.frame = self.originalFrame
                }
                self.show = show
            }
        }
    }
}

open class AWAlbumPopView: UIView, AWPopupViewProtocol {
    @IBOutlet open var bgView: UIView!
    @IBOutlet open var popupView: UIView!
    @IBOutlet var popupViewHeight: NSLayoutConstraint!
    @IBOutlet open var tableView: UITableView!
    @objc var originalFrame = CGRect.zero
    @objc var show = false
    
    deinit {
        //        print("deinit AWAlbumPopView")
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.popupView.layer.cornerRadius = 5.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapBgView))
        self.bgView.addGestureRecognizer(tapGesture)
        
        let nib = UINib(nibName: "AWCollectionTableViewCell", bundle: AWBundle.mainBundle())
        self.tableView.register(nib, forCellReuseIdentifier: "AWCollectionTableViewCell")
    }
    
    @objc func tapBgView() {
        self.show(false)
    }
}
