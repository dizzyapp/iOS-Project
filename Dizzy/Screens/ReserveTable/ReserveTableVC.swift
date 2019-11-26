//
//  ReserveTableViewController.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 19/11/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

extension ReserveTableVC {
    
    enum ButtonType: Int {
        case tonight = 0
        case tomorrow = 1
        case other = 2
        
        var title: String {
            switch self {
            case .tonight: return "tonight".localized
            case .tomorrow: return "tomorrow".localized
            case .other: return "other".localized
            }
        }
    }
}

final class ReserveTableVC: ViewController, CardVC, KeyboardDismissing {
    
    let stackWidthPrecentage = CGFloat(0.75)
    let signInButtonBackgroundColor = UIColor(red:0.43, green:0.38, blue:0.98, alpha:1)
    let signInCornerRadius = CGFloat(17)
    
    var cardContainerView = UIView()
    let titleLabel = UILabel()
    let placeNameLabel = UILabel()
    let mainStackView = UIStackView()
    let nameTextField = UITextField().loginTextfield(withPlaceholder: "Name".localized)
    let numberOfPeopleTextField = UITextField().loginTextfield(withPlaceholder: "Number Of People".localized)
    let sendButton = UIButton(type: .system)

    let buttonsStackView = UIStackView()
    let tonightButton = UIButton(type: .system)
    let tomorrowButton = UIButton(type: .system)
    let otherButton = UIButton(type: .system)
    let closeButton = UIButton()
    
    let commentsTextView = UITextView(frame: .zero)
    
    let viewModel: ReserveTableVMType
    
    init(viewModel: ReserveTableVMType) {
        self.viewModel = viewModel
        super.init()
        bindViewModel()
        addSubviews()
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViewModel() {
        viewModel.otherButtonOnFocuse.bind { [weak self] onFocuse in
            self?.commentsTextView.isHidden = !onFocuse
        }
        
        if !viewModel.userName.isEmpty {
            nameTextField.text = viewModel.userName
            numberOfPeopleTextField.becomeFirstResponder()
        } else {
            nameTextField.becomeFirstResponder()
        }
    }
    
    private func addSubviews() {
        cardContainerView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(nameTextField)
        mainStackView.addArrangedSubview(numberOfPeopleTextField)
        mainStackView.addArrangedSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(tonightButton)
        buttonsStackView.addArrangedSubview(tomorrowButton)
        buttonsStackView.addArrangedSubview(otherButton)
        mainStackView.addArrangedSubview(commentsTextView)
        mainStackView.addArrangedSubview(sendButton)
        view.addSubview(closeButton)
        view.addSubview(placeNameLabel)
    }
    
    private func setupViews() {
        commentsTextView.isHidden = true
        makeCard()
        setupTitleLabel()
        setupMainmainStackView()
        setupButtonsStackView()
        setup(tonightButton, with: .tonight)
        setup(tomorrowButton, with: .tomorrow)
        setup(otherButton, with: .other)
        setupSendButton()
        setupCommentsTextView()
        addGestures()
        setupPlaceNameLabel()
        setupCloseButton()
        numberOfPeopleTextField.keyboardType = .numberPad
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Reserve a table".localized
        titleLabel.textAlignment = .center
        titleLabel.textColor = .primeryPurple
    }
    
    private func setupMainmainStackView() {
        mainStackView.alignment = .fill
        mainStackView.axis = .vertical
        mainStackView.spacing = Metrics.doublePadding
    }
    
    private func setupButtonsStackView() {
        buttonsStackView.alignment = .fill
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = Metrics.doublePadding
    }
    
    private func setupSendButton() {
        sendButton.setTitle("SEND".localized, for: .normal)
        sendButton.titleLabel?.font = Fonts.h10(weight: .bold)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.layer.cornerRadius = signInCornerRadius
        sendButton.backgroundColor = signInButtonBackgroundColor
        sendButton.addTarget(self, action: #selector(onSendPressed), for: .touchUpInside )
    }
    
    private func setupCloseButton() {
        closeButton.setImage(Images.whiteBackButton(), for: .normal)
        closeButton.addTarget(self, action: #selector(onCloasePressed), for: .touchUpInside )
    }
    
    private func setup(_ button: UIButton, with buttonType: ButtonType) {
        button.tag = buttonType.rawValue
        button.setTitle(buttonType.title, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    private func setupPlaceNameLabel() {
        placeNameLabel.text = viewModel.placeName
        placeNameLabel.textAlignment = .center
        placeNameLabel.textColor = .white
        placeNameLabel.font = Fonts.h1(weight: .bold)
    }
    
    private func setupCommentsTextView() {
        commentsTextView.font = Fonts.h10()
        commentsTextView.textContainer.maximumNumberOfLines = 2
        commentsTextView.textContainer.lineBreakMode = .byWordWrapping
        commentsTextView.setBorder(borderColor: .lightGray)
    }
    
    private func layoutViews() {
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metrics.padding)
            make.leading.equalToSuperview().offset(Metrics.doublePadding)
            make.trailing.equalToSuperview().inset(Metrics.doublePadding)
        }
        
        tonightButton.snp.makeConstraints { make in
            make.width.equalTo(tomorrowButton)
            make.width.equalTo(otherButton)
        }
        
        commentsTextView.snp.makeConstraints { make in
            make.height.equalTo(Metrics.sixTimesPadding)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Metrics.fourTimesPadding)
            make.trailing.equalToSuperview().inset(Metrics.doublePadding)
        }
        
        placeNameLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(closeButton.snp.bottom).offset(Metrics.doublePadding)
        }
    }
    
    func makeCardConstraints() {
        cardContainerView.snp.makeConstraints { loginContainerView in
            loginContainerView.top.equalTo(view.snp.topMargin).offset(Metrics.eightTimesPadding)
            loginContainerView.leading.trailing.equalToSuperview()
            loginContainerView.bottom.equalToSuperview().offset(Metrics.oneAndHalfPadding)
        }
    }
    
    private func addGestures() {
        let downSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(onDownSwipe))
        downSwipeGesture.direction = .down
        cardContainerView.addGestureRecognizer(downSwipeGesture)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onCardViewPressed))
         self.cardContainerView.addGestureRecognizer(tap)
    }
    
    @objc private func onSendPressed() {
        viewModel.requestATable(with: nameTextField.text, numberOfPeople: numberOfPeopleTextField.text, time: "", comment: commentsTextView.text)
    }
    
    private func returnButtonToIntialColor() {
        tonightButton.setTitleColor(.blue, for: .normal)
        tomorrowButton.setTitleColor(.blue, for: .normal)
        otherButton.setTitleColor(.blue, for: .normal)
    }
    
    @objc private func buttonPressed(_ button: UIButton) {
        returnButtonToIntialColor()
        button.setTitleColor(.primeryPurple, for: .normal)
        viewModel.otherButtonOnFocuse.value = button == otherButton
    }
    
    @objc private func onDownSwipe() {
        viewModel.didFinish()
    }

    @objc private func onCloasePressed() {
        viewModel.didFinish()
    }
    
    @objc private func onCardViewPressed() {
        view.endEditing(true)
    }
}
