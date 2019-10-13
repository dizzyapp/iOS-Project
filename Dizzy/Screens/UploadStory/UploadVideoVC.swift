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
    private var place: PlaceInfo
    private let videoView = VideoView()
    private let uploadButton = UIButton(type: .system)
    private let interactor: UploadFileInteractorType
    
    init(interactor: UploadFileInteractorType, place: PlaceInfo) {
        self.interactor = interactor
        self.place = place
        super.init(nibName: nil, bundle: nil)
        
        addSubViews()
        layoutViews()
        setupViews()
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
        view.addSubviews([videoView, uploadButton])
    }
    
    private func layoutViews() {
        videoView.snp.makeConstraints { videoView in
            videoView.edges.equalToSuperview()
        }
        
        uploadButton.snp.makeConstraints { uploadButton in
            uploadButton.bottom.equalTo(view.snp.bottomMargin).offset(-100)
            uploadButton.centerX.equalToSuperview()
        }
    }
    
    private func setupViews() {
        uploadButton.setTitle("upload", for: .normal)
        uploadButton.addTarget(self, action: #selector(onUploadPressed), for: .touchUpInside)
    }
    
    @objc private func onUploadPressed() {
        print("menash logs - uploadingVideo")
        interactor.uplaodVideo(path: "\(place.name)/\(UUID().uuidString).mp4", data: UploadFileData(data: nil, fileURL: self.videoPathURL!), placeInfo: place) { result in
            switch result {
            case .success(let uploadRes):
                print("menash logs - success: \(uploadRes)")
                return
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setURL(url: URL) {
        videoPathURL = url
    }

}
