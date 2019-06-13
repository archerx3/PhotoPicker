//
//  AWPhotoCaptureDelegate.swift
//  PhotoPicker
//
//  Created by archer.chen on 6/13/19.
//  Copyright © 2019 CA. All rights reserved.
//

import AVFoundation
import Photos

@available(iOS 10.2, *)
class AWPhotoCaptureProcessor: NSObject {
    private(set) var requestedPhotoSettings: AVCapturePhotoSettings
    
    private let willCapturePhotoAnimation: () -> Void
    
    private let livePhotoCaptureHandler: (Bool) -> Void
    
    private let completionHandler: (AWPhotoCaptureProcessor) -> Void
    
    private var photoData: Data?
    
    private var livePhotoCompanionMovieURL: URL?
    
    init(with requestedPhotoSettings: AVCapturePhotoSettings,
         willCapturePhotoAnimation: @escaping () -> Void,
         livePhotoCaptureHandler: @escaping (Bool) -> Void,
         completionHandler: @escaping (AWPhotoCaptureProcessor) -> Void) {
        self.requestedPhotoSettings = requestedPhotoSettings
        self.willCapturePhotoAnimation = willCapturePhotoAnimation
        self.livePhotoCaptureHandler = livePhotoCaptureHandler
        self.completionHandler = completionHandler
    }
    
    private func didFinish() {
        if let livePhotoCompanionMoviePath = livePhotoCompanionMovieURL?.path {
            if FileManager.default.fileExists(atPath: livePhotoCompanionMoviePath) {
                do {
                    try FileManager.default.removeItem(atPath: livePhotoCompanionMoviePath)
                } catch {
                    print("Could not remove file at url: \(livePhotoCompanionMoviePath)")
                }
            }
        }
        
        completionHandler(self)
    }
    
}

@available(iOS 10.2, *)
extension AWPhotoCaptureProcessor: AVCapturePhotoCaptureDelegate {
    /*
     This extension includes all the delegate callbacks for AVCapturePhotoCaptureDelegate protocol
     */
    
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        if resolvedSettings.livePhotoMovieDimensions.width > 0 && resolvedSettings.livePhotoMovieDimensions.height > 0 {
            livePhotoCaptureHandler(true)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        willCapturePhotoAnimation()
    }
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let error = error {
            print("Error capturing photo: \(error)")
        } else {
            photoData = photo.fileDataRepresentation()
        }
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishRecordingLivePhotoMovieForEventualFileAt outputFileURL: URL, resolvedSettings: AVCaptureResolvedPhotoSettings) {
        livePhotoCaptureHandler(false)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingLivePhotoToMovieFileAt outputFileURL: URL, duration: CMTime, photoDisplayTime: CMTime, resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        if error != nil {
            print("Error processing live photo companion movie: \(String(describing: error))")
            return
        }
        livePhotoCompanionMovieURL = outputFileURL
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            didFinish()
            return
        }
        
        guard let photoData = photoData else {
            print("No photo data resource")
            didFinish()
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    let options = PHAssetResourceCreationOptions()
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    if #available(iOS 11.0, *) {
                        options.uniformTypeIdentifier = self.requestedPhotoSettings.processedFileType.map { $0.rawValue }
                    } else {
                        // Fallback on earlier versions
                    }
                    creationRequest.addResource(with: .photo, data: photoData, options: options)
                    
                    if let livePhotoCompanionMovieURL = self.livePhotoCompanionMovieURL {
                        let livePhotoCompanionMovieFileResourceOptions = PHAssetResourceCreationOptions()
                        livePhotoCompanionMovieFileResourceOptions.shouldMoveFile = true
                        creationRequest.addResource(with: .pairedVideo, fileURL: livePhotoCompanionMovieURL, options: livePhotoCompanionMovieFileResourceOptions)
                    }
                    
                }, completionHandler: { _, error in
                    if let error = error {
                        print("Error occurered while saving photo to photo library: \(error)")
                    }
                    
                    self.didFinish()
                }
                )
            } else {
                self.didFinish()
            }
        }
    }
}

