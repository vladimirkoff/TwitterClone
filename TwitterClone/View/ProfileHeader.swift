//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 03.03.2023.
//

import UIKit

protocol DismissprofileDelegate {
    func dismissProfile()
    func handleEditProfileFollow(_ header: ProfileHeader)
}

class ProfileHeader: UICollectionReusableView {
    
   
    //MARK: - Properties
    
    private let profileCategory = ProfileCategory()
    
    var delegate: DismissprofileDelegate?
    
    var user: User? {
        didSet {
            configure()
        }
    }
    
    private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .twitterBlue
    view.addSubview(backButton)
    backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 42, paddingLeft: 16)
        
        
    profileCategory.delegate = self
        
    return view
    }()
    
    private let fullNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 20)
    return label
    }()
    
    private let userNamelabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .lightGray
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
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        
        let followTap = UIGestureRecognizer(target: self, action: #selector(followingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        label.text = "0 Following"
        
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        
        let followersTap = UIGestureRecognizer(target: self, action: #selector(followersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followersTap)
        label.text = "0 Followers"
        
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
        
        let followStack = UIStackView(arrangedSubviews: [followersLabel, followingLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fillEqually
        
        addSubview(userInfoStack)
        userInfoStack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        addSubview(profileCategory)
        profileCategory.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width/3, height: 2)
        
        addSubview(followStack)
        followStack.anchor(top: userInfoStack.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    
    //MARK: - Selector
    
    @objc func goBack() {
        delegate?.dismissProfile()
    }
    
    @objc func followButtonPressed() {
        delegate?.handleEditProfileFollow(self)
    }
    
    @objc func followingTapped() {
        print("Following tapped")
    }
    
    @objc func followersTapped() {
        print("Followers tapped")
    }
    
    
}

extension ProfileHeader: ProfileCategoryDelegate {
    func animateSelector(_ view: ProfileCategory, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileCategoryCell else { return }
        
        let xPos = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPos
        }
    }
    
    func configure() {
        guard let user = user else { return }
        let viewModel = ProfileHeaderViewModel(user: user)
        followingLabel.attributedText = viewModel.followingString
        followersLabel.attributedText = viewModel.followersString
        
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl))
        userNamelabel.text = "@\(user.userName)"
        fullNameLabel.text = user.fullName
        
        editProfileButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        
    }
}
