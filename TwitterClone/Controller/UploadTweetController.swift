//
//  UploadTweetController.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 02.03.2023.
//

import UIKit
import SDWebImage
import ActiveLabel

class UploadTweetController: UIViewController {
    
    //MARK: - Properties
    
    private lazy var actionButton: UIButton = {  // lazy! if there is a target
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(uploadTweet), for: .touchUpInside)
        return button
    }()
    
    private lazy var replyLabel: ActiveLabel = {  // when trying to access view from inside the block we need to use LAZY
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.mentionColor = .twitterBlue
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    private let user: User
    private let config: UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: config)
    private let captionTextView = CaptionTextView()
    
    //MARK: - Lifecycle
    
    init(user: User, config: UploadTweetConfiguration) {   // passing user from another controller
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
        handleMentionTap()
    }
    
    
    
    //MARK: - Selector
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func uploadTweet() {
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption, type: config) { error, ref in
            if case .reply(let tweet) = self.config {
                NotificationService.shared.uploadNotification(type: .reply, tweet: tweet)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .leading
        
        let newStack = UIStackView(arrangedSubviews: [replyLabel, stack])
        newStack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 14
        
        
        view.backgroundColor = .white
        
        view.addSubview(newStack)
        newStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        
        guard let url = URL(string: user.profileImageUrl) else { return }
        profileImageView.sd_setImage(with: url)
        
        actionButton.setTitle(viewModel.actiomButtonTitle, for: .normal)
        captionTextView.placeHolder.text = viewModel.placeholderText
        
        replyLabel.isHidden = !viewModel.shouldShowReply
        
        guard let replyText = viewModel.replyText else { return }
        
        replyLabel.text = replyText
        
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    func handleMentionTap() {
        replyLabel.handleMentionTap { mention in
            print("DEBUG: mentioned user is \(mention)")
        }
    }
}
