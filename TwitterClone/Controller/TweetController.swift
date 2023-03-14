//
//  TweetController.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 06.03.2023.
//

import UIKit

private var headerIdentifier = "TweetHeader"
private var cellIdentifier = "TweetCell"

class TweetController: UICollectionViewController {
    //MARK: - Properties
    
    private var tweet: Tweet
    private var actionSheet: ActionSheetLauncher!
    private var replies = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    
    init(tweet: Tweet) {
        self.tweet = tweet
//        self.actionSheet = ActionSheetLauncher(user: tweet.user)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        fetchReplies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    //MARK: - API
    
    
    func fetchReplies() {
        TweetService.shared.fetchReplies(tweet: tweet) { replies in
            self.replies = replies
        }
    }
    
    
    
    //MARK: - Helpers
    
    func configure() {
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
}

extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TweetCell
        cell.tweet = replies[indexPath.row]
        return cell
    }
}

extension TweetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let viewModel = TweetViewModel(tweet: tweet)
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: captionHeight + 260)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! TweetHeader
        print("Here")
        header.tweet = self.tweet
        header.delegate = self
        return header // creating header
    }
    
}

extension TweetController: TweetHeaderDelegate {
    func showActionSheet() {
        if tweet.user.isCurrentuser {
            actionSheet = ActionSheetLauncher(user: tweet.user)
            self.actionSheet.delegate = self
            actionSheet.show()
        } else {
            UserService.shared.checkIfFollowed(tweet.user.uid) { isFollowed in
                var user = self.tweet.user
                user.isFollowed = isFollowed
                self.actionSheet = ActionSheetLauncher(user: user)
                self.actionSheet.delegate = self
                self.actionSheet.show()
            }
        }
    }
}

extension TweetController: ActionSheetDelegate {
    func didSelect(option: ActionSheetOptions) {
        switch option {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { error, ref in
                print("Did follow user ")
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { err, ref in
                print("Did unfollow")
            }
        case .report:
            print("DEBUG: ERPORT")
        case .delete:
            print("DELETE")
        }
    }
    
}
