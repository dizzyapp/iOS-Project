//
//  SearchBar.swift
//  Dizzy
//
//  Created by Menashe, Or on 16/11/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol SearchBarDelegate: class {
    func searchTextChanged(newText: String)
    func closePressed()
}

class SearchBar: UIView {
    weak var delegate: SearchBarDelegate?
    private let searchTextField = UITextField()
    private let closeButton = UIButton(type: .system).navigaionCloseButton
    
    init() {
        super.init(frame: CGRect.zero)
        addViews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubviews([searchTextField, closeButton])
    }
    
    private func layoutViews() {
        searchTextField.snp.makeConstraints { searchTextField in
            searchTextField.top.equalTo(closeButton.snp.top)
            searchTextField.bottom.equalTo(closeButton.snp.bottom)
            searchTextField.leading.equalToSuperview()
            searchTextField.trailing.equalTo(closeButton.snp.leading).offset(-Metrics.doublePadding)
        }
        
        closeButton.snp.makeConstraints { closeButton in
            closeButton.top.equalToSuperview()
            closeButton.bottom.equalToSuperview().offset(-Metrics.padding)
            closeButton.trailing.equalToSuperview()
        }
        
        closeButton.setContentHuggingPriority(UILayoutPriority(999), for: .horizontal)
    }
    
    private func setupViews() {
        setupSearchTextField()
        setupCloseButton()
    }
    
    private func setupCloseButton() {
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
    }
    
    private func setupSearchTextField() {
        searchTextField.delegate = self
        searchTextField.autocorrectionType = .no
        searchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        searchTextField.textColor = UIColor.white
        searchTextField.font = Fonts.h7(weight: .bold)
        searchTextField.layer.cornerRadius = 16
        searchTextField.addPaddingToMarker()
        searchTextField.addTarget(self, action: #selector(searchTextFieldDidChange), for: .editingChanged)
    }
    
    func stopEditing() {
        self.endEditing(true)
        self.searchTextField.text = ""
    }
    
    func startEditing() {
        searchTextField.becomeFirstResponder()
    }
    
    @objc func closeButtonPressed() {
        delegate?.closePressed()
    }
    
    @objc func searchTextFieldDidChange() {
        delegate?.searchTextChanged(newText: searchTextField.text ?? "")
    }
}

extension SearchBar: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
}
