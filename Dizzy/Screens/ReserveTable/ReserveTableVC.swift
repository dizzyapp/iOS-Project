//
//  ReserveTableViewController.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 19/11/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

extension ReserveTableVC {
    
    enum ReservationTime: Int {
        case tonight = 0
        case tomorrow = 1
        case other = 2
        
        var title: String {
            switch self {
            case .tonight: return "Tonight".localized
            case .tomorrow: return "Tomorrow".localized
            case .other: return "Other".localized
            }
        }
    }
    
    enum ReservationMethod {
        case table
        case bar
        
        var text: String {
            switch self {
            case .table:
                return "a table".localized
                
            case .bar:
                return "a spot on the bar".localized
            }
        }
    }
}

final class ReserveTableVC: ViewController, CardVC, KeyboardDismissing {
    
    let stackWidthPrecentage = CGFloat(0.75)
    let signInButtonBackgroundColor = UIColor.blue
    let signInCornerRadius = CGFloat(15)
    
    var cardContainerView = UIView()
    let titleLabel = UILabel()
    let placeNameLabel = UILabel()
    let mainStackView = UIStackView()
    let nameTextField = UITextField().loginTextfield(withPlaceholder: "Your full name".localized)
    let numberOfPeopleTextField = UITextField().loginTextfield(withPlaceholder: "For how many people?".localized)
    let sendButton = UIButton(type: .system)

    let buttonsStackView = UIStackView()
    let tonightButton = UIButton(type: .system)
    let tomorrowButton = UIButton(type: .system)
    let otherButton = UIButton(type: .system)
    let closeButton = UIButton()
    
    private let reserveMethodStackView = UIStackView()
    let tableButton = UIButton(type: .system)
    let onBarButton = UIButton(type: .system)
    
    let commentsTextView = UITextView(frame: .zero)
    
    var viewModel: ReserveTableVMType
    
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
        viewModel.selectedTime.bind { [weak self] selectedTime in
            self?.commentsTextView.isHidden = selectedTime != .other
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
        mainStackView.addArrangedSubview(reserveMethodStackView)
        reserveMethodStackView.addArrangedSubview(tableButton)
        reserveMethodStackView.addArrangedSubview(onBarButton)
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
        nameTextField.autocorrectionType = .no
        setupReserveTableButton()
        setupReserveOnBarButton()
        setupReserveMethodStackView()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Book a Table" .localized
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.dizzyBlue
        titleLabel.font = Fonts.i3(weight: .bold)
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
    
    private func setupReserveMethodStackView() {
        reserveMethodStackView.alignment = .fill
        reserveMethodStackView.axis = .horizontal
        reserveMethodStackView.spacing = Metrics.doublePadding
    }
    
    private func setupSendButton() {
        sendButton.setTitle("Continue to WhatsApp".localized, for: .normal)
        sendButton.titleLabel?.font = Fonts.h8(weight: .bold)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.layer.cornerRadius = signInCornerRadius
        sendButton.backgroundColor = signInButtonBackgroundColor
        sendButton.addTarget(self, action: #selector(onSendPressed), for: .touchUpInside )
    }
    
    private func setupCloseButton() {
        closeButton.setImage(Images.exitStoryButton(), for: .normal)
        closeButton.addTarget(self, action: #selector(onCloasePressed), for: .touchUpInside )
    }
    
    private func setup(_ button: UIButton, with reservationTime: ReservationTime) {
        button.tag = reservationTime.rawValue
        button.setTitle(reservationTime.title, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setBorder(borderColor: .blue, cornerRadius: 15)
        button.titleLabel?.font = Fonts.h8(weight: .bold)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    private func setupReserveTableButton() {
        tableButton.setTitle("Table".localized, for: .normal)
        tableButton.setTitleColor(.blue, for: .normal)
        tableButton.titleLabel?.font = Fonts.h8(weight: .bold)
        tableButton.layer.cornerRadius = signInCornerRadius
        select(button: tableButton)
        tableButton.addTarget(self, action: #selector(onTablePressed), for: .touchUpInside)
    }
    
    private func setupReserveOnBarButton() {
        onBarButton.setTitle("On The Bar".localized, for: .normal)
        onBarButton.setTitleColor(.blue, for: .normal)
        onBarButton.titleLabel?.font = Fonts.h8(weight: .bold)
        onBarButton.layer.cornerRadius = signInCornerRadius
        unSelect(button: onBarButton)
        onBarButton.addTarget(self, action: #selector(onBarPressed), for: .touchUpInside)
    }
    
    private func setupPlaceNameLabel() {
        placeNameLabel.text = viewModel.placeName
        placeNameLabel.textAlignment = .center
        placeNameLabel.textColor = .darkDizzyBlue
        placeNameLabel.font = Fonts.h1(weight: .bold)
    }
    
    private func setupCommentsTextView() {
        commentsTextView.font = Fonts.h10()
        commentsTextView.textContainer.maximumNumberOfLines = 2
        commentsTextView.textContainer.lineBreakMode = .byWordWrapping
        commentsTextView.backgroundColor = nameTextField.backgroundColor
        commentsTextView.layer.cornerRadius = nameTextField.layer.cornerRadius
        commentsTextView.autocorrectionType = .no
    }
    
    private func layoutViews() {
        
        tableButton.snp.makeConstraints { make in
            make.width.equalTo(onBarButton)
        }
        
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
            make.top.equalToSuperview().inset(Metrics.fiveTimesPadding)
            make.trailing.equalToSuperview().inset(Metrics.doublePadding)
        }
        
        placeNameLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.bottom.equalTo(closeButton.snp.bottom)
        }
    }
    
    func makeCardConstraints() {
        cardContainerView.snp.makeConstraints { loginContainerView in
            loginContainerView.top.equalTo(view.snp.topMargin).offset(Metrics.sevenTimesPadding)
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
        viewModel.requestATable(with: nameTextField.text, numberOfPeople: numberOfPeopleTextField.text, comment: commentsTextView.text)
    }
    
    private func returnButtonToIntialColor() {
        tonightButton.setTitleColor(.blue, for: .normal)
        tonightButton.setBorder(borderColor: .white, cornerRadius: 15)
        tonightButton.backgroundColor = .white
        tomorrowButton.setTitleColor(.blue, for: .normal)
        tomorrowButton.setBorder(borderColor: .white, cornerRadius: 15)
        tomorrowButton.backgroundColor = .white
        otherButton.setTitleColor(.blue, for: .normal)
        otherButton.setBorder(borderColor: .white, cornerRadius: 15)
        otherButton.backgroundColor = .white
    }
    
    @objc private func buttonPressed(_ button: UIButton) {
        returnButtonToIntialColor()
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .white
        button.setBorder(borderColor: .blue, cornerRadius: 15)

        switch button {
        case tonightButton:
            viewModel.selectedTime.value = .tonight
        case tomorrowButton:
            viewModel.selectedTime.value = .tomorrow
        default:
            viewModel.selectedTime.value = .other
        }
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
    
    @objc private func onTablePressed() {
        select(button: tableButton)
        unSelect(button: onBarButton)
        viewModel.selectedReservetionMethod = .table
    }
    
    @objc private func onBarPressed() {
        select(button: onBarButton)
        unSelect(button: tableButton)
        viewModel.selectedReservetionMethod = .bar
    }
    
    private func select(button: UIButton) {
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 1
    }
    
    private func unSelect(button: UIButton) {
        button.layer.borderWidth = 0
    }
}
