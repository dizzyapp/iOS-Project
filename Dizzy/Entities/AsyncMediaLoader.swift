//
//  AsyncMediaLoader.swift
//  Dizzy
//
//  Created by Menashe, Or on 24/01/2020.
//  Copyright © 2020 Dizzy. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

protocol AsyncMediaLoaderType {
    func setMediaArray(_ mediaArray: [PlaceMedia])
    func getView(forPlaceMedia placeMedia: PlaceMedia?) -> UIView?
    var showVideosInLoop: Bool { get set }
}

class AsyncMediaLoader: AsyncMediaLoaderType {
    
    private var mediaArray = [PlaceMedia]()
    private var viewPerMedia: [String: UIView] = [:]
    public var showVideosInLoop = false
    
    public func setMediaArray(_ mediaArray: [PlaceMedia]) {
        self.mediaArray = mediaArray
        for media in mediaArray {
            guard let downloadLink = media.downloadLink,
                let url = URL(string: downloadLink) else {
                    break
            }
            
            if media.isVideo() {
                addVideoView(forLink: url)
            } else {
                addImageView(forLink: url)
            }
        }
    }
    
    private func addVideoView(forLink link: URL) {
        let videoView = VideoView()
        videoView.configure(url: link)
        videoView.isLoop = showVideosInLoop
        viewPerMedia[link.absoluteString] = videoView
    }
    
    private func addImageView(forLink link: URL) {
        let imageView = UIImageView()
        imageView.kf.setImage(with: link)
        imageView.contentMode = .scaleAspectFill
        viewPerMedia[link.absoluteString] = imageView
    }
    
    public func getView(forPlaceMedia placeMedia: PlaceMedia?) -> UIView? {
        
        return viewPerMedia[placeMedia?.downloadLink ?? ""]
    }
}
