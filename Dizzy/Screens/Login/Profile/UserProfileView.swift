//
//  UserProfileView.swift
//  Dizzy
//
//  Created by stas berkman on 13/06/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseAuth
import FirebaseStorage

protocol UserProfileViewDelegate: class {
    func profileButtonPressed()
}

class UserProfileView: UIView {

    let profileButton = UIButton()
    let profileNameLabel = UILabel()
    
    private let databaseReference: DatabaseReference = Database.database().reference()
    let storageReference: StorageReference = Storage.storage().reference()
    
    weak var delegate: UserProfileViewDelegate?

    let nameColor = UIColor.black.withAlphaComponent(0.53)
    let profileButtonWidth: CGFloat = 80
    
    init() {
        super.init(frame: CGRect.zero)
        
        addSubviews()
        layoutViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.addSubviews([profileButton, profileNameLabel])
    }
    
    private func layoutViews() {
        layoutProfileImageView()
        layoutProfileNameLabel()
    }
    
    private func layoutProfileImageView() {
        profileButton.snp.makeConstraints { profileButton in
            profileButton.top.equalToSuperview()
            profileButton.centerX.equalToSuperview()
            profileButton.width.equalTo(profileButtonWidth)
            profileButton.height.equalTo(profileButtonWidth)
        }
    }
    
    private func layoutProfileNameLabel() {
        profileNameLabel.snp.makeConstraints { profileNameLabel in
            profileNameLabel.top.equalTo(profileButton.snp.bottom).offset(Metrics.doublePadding)
            profileNameLabel.centerX.equalTo(profileButton.snp.centerX)
        }
    }
    
    private func setupViews() {
        setupProfileButton()
        setupProfileNameLabel()
    }
    
    private func setupProfileButton() {
        self.profileButton.layer.cornerRadius = profileButtonWidth / 2
        self.profileButton.layer.masksToBounds = true
        self.profileButton.contentMode = .center
        
        if let uid = Auth.auth().currentUser?.uid {
            databaseReference.child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                print(snapshot)
                if let dict = snapshot.value as? [String: AnyObject] {
                    if let imageURLString = dict["photoURL"] as? String {
                        self.profileButton.kf.setImage(with: URL(string: imageURLString), for: .normal, placeholder: Images.profilePlaceholderIcon())
                    }
                }
            }
        }
        
        self.profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
    }
    
    private func setupProfileNameLabel() {
        self.profileNameLabel.text = Auth.auth().currentUser?.displayName ?? "Test User".localized
        self.profileNameLabel.textColor = nameColor
        self.profileNameLabel.font = Fonts.h6()
    }
    
    public func updateProfileImage(_ image: UIImage) {
        self.profileButton.setImage(image, for: .normal)
    }
    
    public func saveChanges() {
        let imageName = NSUUID().uuidString
        let storedImage = storageReference.child("profile_images").child(imageName)
        
        if let image = self.profileButton.image(for: .normal), let imageData = image.jpegData(compressionQuality: 0.8) {
            storedImage.putData(imageData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error)
                    return
                }
                
                storedImage.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    if let urlText = url?.absoluteString, let uid = Auth.auth().currentUser?.uid {
                        self.databaseReference.child("users").child(uid).updateChildValues(["photoURL" : urlText], withCompletionBlock: { (error, reference) in
                            if error != nil {
                                print(error)
                                return
                            }
                        })
                    }
                })
            }
        }
    }
}

extension UserProfileView {
    @objc private func profileButtonPressed() {
        self.delegate?.profileButtonPressed()
    }
}
