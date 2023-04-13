//
//  MainTabController.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 01.03.2023.
//

import UIKit
import FirebaseAuth

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    
    private var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            feed.user = user
            
            let chat = ProfileController(user: user!)
            let nav4 = templateNavigationController(image: UIImage(named: "profile_unselected"), rootVC: chat)
            nav4.navigationController?.navigationBar.isHidden = true
            
            viewControllers?.append(nav4)
        }
    }
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twitterBlue
        authenticateUser()
        tabBar.backgroundColor = .white
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor( bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56 )
        actionButton.layer.cornerRadius = 56 / 2
        
    }
    
    func configureViewControllers() {
        
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected"), rootVC: feed)
        
        let explore = ExploreController()
        let nav2 = templateNavigationController(image: UIImage(named: "search_unselected"), rootVC: explore)
        
        let notifications = NotificationsController()
        let nav3 = templateNavigationController(image: UIImage(named: "like_unselected"), rootVC: notifications)
        

        
        viewControllers = [nav1, nav2, nav3]
        
        
    }
    
    func templateNavigationController(image: UIImage?, rootVC: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootVC)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }
    
    //MARK: - Selectors
    
    @objc func actionButtonPressed() {
        guard let useR = self.user else { return }
        let controller = UploadTweetController(user: useR, config: .tweet)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    func authenticateUser() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            
        } else {
            fetchUser()
            configureViewControllers()
            configureUI()
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error logging out - \(error.localizedDescription)")
        }
    }
}
