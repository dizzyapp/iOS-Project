//
//  UploadVideoVC.swift
//  Dizzy
//
//  Created by Menashe, Or on 12/10/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

class UploadVideoVC: UIViewController {

    private var videoPathURL: URL?
    private let videoView = VideoView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        addSubViews()
        layoutViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let videoPathURL = videoPathURL else { return }
        videoView.configure(url: videoPathURL)
        videoView.isLoop = true
        videoView.play()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        view.addSubviews([videoView])
    }
    
    private func layoutViews() {
        videoView.snp.makeConstraints { videoView in
            videoView.edges.equalToSuperview()
        }
    }
    
    func setURL(url: URL) {
        videoPathURL = url
    }

}
