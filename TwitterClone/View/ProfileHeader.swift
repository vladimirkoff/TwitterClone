//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 03.03.2023.
//

import UIKit

class ProfileHeader: UICollectionReusableView {
    
    //MARK: - Properties
    
    private let profileCategory = ProfileCategory()
    
    private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .twitterBlue
    view.addSubview(backButton)
    backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 42, paddingLeft: 16)
        
        
        
        
    return view
    }()
    
    private let fullNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 20)
    label.text = "Vladimir Kovalev"
    return label
    }()
    
    private let userNamelabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.text = "@vladimir"
    return label
    }()

    private lazy var backButton: UIButton = {
    let button = UIButton(type: .system)
        button.setImage(UIImage(named: "baseline_arrow_back_white_24dp"), for: .normal)
    button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    return button
    }()

    private lazy var profileImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleToFill
    iv.clipsToBounds = true
    iv.layer.cornerRadius = 24
    iv.backgroundColor = .lightGray
    iv.layer.borderColor = UIColor.white.cgColor
    iv.layer.borderWidth = 4
    return iv
    }()

    private lazy var editProfileButton: UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = .white
    button.setTitle("Loading", for: .normal)
    button.layer.borderColor = UIColor.twitterBlue.cgColor
    button.layer.borderWidth = 1.25
    button.layer.cornerRadius = 36 / 2
    button.titleLabel?.textAlignment = .center
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.twitterBlue, for: .normal)
    button.addTarget(self, action: #selector(followButtonPressed), for: .touchUpInside)
    return button
    }()

    private let bioLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.numberOfLines = 3
    label.text = "This is a user bio that will span more than one line for test purposes"
    return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 108)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor, paddingTop: -24, paddingLeft: 8)
        profileImageView.setDimensions(width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: containerView.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
        
        editProfileButton.setDimensions(width: 100, height: 36)
        editProfileButton.layer.cornerRadius = 36 / 2
        
        let userInfoStack = UIStackView(arrangedSubviews: [fullNameLabel, userNamelabel, bioLabel])
        userInfoStack.axis = .vertical
        userInfoStack.distribution = .fillProportionally
        userInfoStack.spacing = 4
        
        addSubview(userInfoStack)
        userInfoStack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        addSubview(profileCategory)
        profileCategory.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    
    //MARK: - Selector
    
    @objc func goBack() {
        print("Went back")
    }
    
    @objc func followButtonPressed() {
        print("Followed")
    }
    
    
}
