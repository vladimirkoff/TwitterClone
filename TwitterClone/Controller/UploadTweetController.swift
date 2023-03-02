//
//  UploadTweetController.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 02.03.2023.
//

import UIKit
import SDWebImage

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
    
    private let captionTextView = CaptionTextView()
    
    //MARK: - Lifecycle
    
     init(user: User) {   // passing user from another controller
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigationBar()
        print("Username - \(user.userName)")
    }
    
    
    
    //MARK: - Selector
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func uploadTweet() {
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption) { error, ref in
            print("UPLOADED")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK: - API
    
    //MARK: - Helpers
    
    func configureUI() {
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.backgroundColor = .white
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        
        
        
        guard let url = URL(string: user.profileImageUrl) else { return }
        profileImageView.sd_setImage(with: url)
        
        
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
//        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
}
