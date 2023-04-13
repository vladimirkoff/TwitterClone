//
//  ProfileController.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 03.03.2023.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
    
    //MARK: - Properties
    
    private var user: User
    
    private var selectedCategory: ProfileCategoryOptions = .tweets {
        didSet { collectionView.reloadData() }
    }
    
    private var tweets = [Tweet]()
    private var likedTweets = [Tweet]()
    private var replies = [Tweet]()
    
    private var currentDataSource: [Tweet] {
        switch selectedCategory {
        case .tweets: return tweets
        case .replies: return replies
        case .likes: return likedTweets
        }
    }
    
    //MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTweets()
        fetchReplies()
        configureUI()
        fetchLikedTweets()
        checkIfUserIsFollowed()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        fetchUserStats()
        view.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never // prolonges the header up to the top end of the screen
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset.bottom = tabHeight
    }
}

//MARK: - UICollectionViewDataSource/Delegate

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: currentDataSource[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = currentDataSource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: currentDataSource[indexPath.row])
        var height = viewModel.size(forWidth: view.frame.width).height + 72
        
        if currentDataSource[indexPath.row].isReply {
            height += 20
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.user = self.user
        header.delegate = self
        return header
    }
    
    //MARK: - API
    
    func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
            self.collectionView.reloadData()
        }
    }
    
    func checkIfUserIsFollowed() {
        UserService.shared.checkIfFollowed(user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchLikedTweets() {
        TweetService.shared.fetchLikes(forUser: user) { tweets in
            self.likedTweets = tweets
        }
    }
    
    func fetchReplies() {
        TweetService.shared.fetchRepliesForUser(user: user) { tweets in
            self.replies = tweets
        }
    }
    
}

//MARK: - DismissprofileDelegate

extension ProfileController: DismissprofileDelegate {

    
    
    func didSelectCategory(category: ProfileCategoryOptions) {
        self.selectedCategory = category
    }
    
    
    func handleEditProfileFollow(_ header: ProfileHeader) {
        if user.isCurrentuser {
            let controller = EditProfileController(user: user)
            let nav = UINavigationController(rootViewController: controller)
            controller.delegate = self
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil )
            return
        }
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { (error, ref) in
                self.user.isFollowed = false
                header.editProfileButton.setTitle("Follow", for: .normal)
                header.editProfileButton.setTitleColor(.white, for: .normal)
                header.editProfileButton.backgroundColor = .twitterBlue
                self.collectionView.reloadData()
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { (error, ref) in
                self.user.isFollowed = true
                header.editProfileButton.setTitle("Unfollow", for: .normal)
                header.editProfileButton.setTitleColor(.twitterBlue, for: .normal)
                header.editProfileButton.backgroundColor = .white
                self.collectionView.reloadData()
                
                NotificationService.shared.uploadNotification(type: .follow, user: self.user)
            }
        }
    }
    
    
    func dismissProfile() {
        navigationController?.popViewController(animated: true)
    }
    
    func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) { stats in
            print("User has \(stats.followers) followers and \(stats.following) following")
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
}

//MARK: - EditProfileControllerDelegate

extension ProfileController: EditProfileControllerDelegate {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User) {
        controller.dismiss(animated: true, completion: nil)
        self.user = user
        collectionView.reloadData()
    }
}


