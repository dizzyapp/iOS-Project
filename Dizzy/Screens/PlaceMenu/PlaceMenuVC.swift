//
//  PlaceMenuVC.swift
//  Dizzy
//
//  Created by Tal Ben Asuli MAC  on 06/01/2020.
//  Copyright © 2020 Dizzy. All rights reserved.
//

import UIKit

final class PlaceMenuVC: ViewController, LoadingContainer {
    
    private let viewModel: PlaceMenuVMType
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    var spinner: UIView & Spinnable = UIActivityIndicatorView(style: .gray)
    
    init(viewModel: PlaceMenuVMType) {
        self.viewModel = viewModel
        super.init()
        addSubviews()
        layoutSubviews()
        bindViewModel()
        setupStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    private func layoutSubviews() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupStackView() {
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = Metrics.padding
    }
    
    private func bindViewModel() {
        viewModel.menuImagesURLs.bind { [weak self] menuURLs in
            guard let self = self else { return }
            for url in menuURLs {
                self.addImageToStack(url.urlString)
            }
        }
        
        viewModel.loading.bind { [weak self] loading in
            loading ? self?.showSpinner() : self?.hideSpinner()
        }
    }
    
    private func addImageToStack(_ urlString: String) {
        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: urlString))
        stackView.addArrangedSubview(imageView)
        layout(imageView)
    }
    
    private func layout(_ imageView: UIImageView) {
        imageView.snp.makeConstraints { make in
            make.width.equalTo(view)
            make.height.equalTo(view)
        }
    }
}
