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
    
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    

    //MARK: - Selector
    
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
    }
    
    //MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTweets()
        configureUI()
        checkIfUserIsFollowed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    
}

//MARK: - UICollectionViewDataSource/Delegate

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.user = self.user
        header.delegate = self
        return header // creating header
    }
    
    //MARK: - API
    
    func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
        }
    }
    
    func checkIfUserIsFollowed() {
        UserService.shared.checkIfFollowed(user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
}

extension ProfileController: DismissprofileDelegate {
    
    func handleEditProfileFollow(_ header: ProfileHeader) {
        if user.isCurrentuser {
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
            }
        }
    }
    
    
    func dismissProfile() {
        navigationController?.popViewController(animated: true) // pops the vc from the stack of view controllers, so it just deletes the top view controller from an array
    }
    
    func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) { stats in
            print("User has \(stats.followers) followers and \(stats.following) following")
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
}


