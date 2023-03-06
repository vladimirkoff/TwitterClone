//
//  TweetHeader.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 06.03.2023.
//

import UIKit

class TweetHeader: UICollectionReusableView {
    
    //MARK: - Proeprties
    
    var tweet: Tweet? {
        didSet { configure() }
    }
    
    private lazy var profileImageView: UIImageView = {  // it must be lazy!
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        
        iv.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToUserProfile))
        iv.addGestureRecognizer(gestureRecognizer)
        
        
        return iv
    }()
    
        private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
        }()
    
        private let userNamelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
        }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0  // infinite number of lines
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "6:33 PM/2023"
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetsLabel = UILabel()
    
    private lazy var likesLabel = UILabel()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        let dividerOne = UIView()
        dividerOne.backgroundColor = .systemGroupedBackground
        view.addSubview(dividerOne)
        dividerOne.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        let stack = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        let dividerTwo = UIView()
        dividerTwo.backgroundColor = .systemGroupedBackground
        view.addSubview(dividerTwo)
        dividerTwo.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        return view
    }()
    
    private lazy var commentButton: UIButton = {
        let button = createButton(withImageName: "comment")
        button.addTarget(self, action: #selector(commentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = createButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(retweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = createButton(withImageName: "like")
        button.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = createButton(withImageName: "share")
        button.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        return button
    }()
    
  
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        let stack = UIStackView(arrangedSubviews: [fullNameLabel, userNamelabel])  // order makes sense ( first - the highest )
        stack.axis = .vertical
        stack.spacing = -6
        
        let imageStack = UIStackView(arrangedSubviews: [profileImageView, stack])
        stack.spacing = 14
        
        addSubview(imageStack)
        imageStack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: imageStack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 16)
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: imageStack)
        optionsButton.anchor(right: rightAnchor, paddingRight: 8)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, height: 40)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        actionStack.spacing = 72
        actionStack.distribution = .fillEqually
        
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(bottom: bottomAnchor, paddingBottom: 12)
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func goToUserProfile() {
        print("Profile image pressed")
    }
    
    @objc func showActionSheet() {
        print("DEBUG: show action sheet")
    }
    
    @objc func commentTapped() {
        print("commentTapped")
    }
    
    @objc func likeTapped() {
        print("likeTapped")
    }
    
    @objc func retweetTapped() {
        print("retweetTapped")
    }
    
    @objc func shareTapped() {
        print("shareTapped")
    }
    
    
    
    //MARK: - Helpers
    
    func configure() {
        print(tweet)
        guard let tweet = self.tweet else { return }
        
        
        let viewModel = TweetViewModel(tweet: tweet)
    
        captionLabel.text = tweet.caption
        userNamelabel.text = viewModel.userName
        fullNameLabel.text = tweet.user.fullName
        profileImageView.sd_setImage(with: URL(string: viewModel.profileImageUrl))
        retweetsLabel.attributedText = viewModel.retweetsString
        likesLabel.attributedText = viewModel.likesString
        dateLabel.text = viewModel.headerTimestamp

    }
    
    func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
}