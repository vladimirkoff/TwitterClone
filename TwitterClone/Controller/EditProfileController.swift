//
//  EditProfileController.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 14.03.2023.
//

import UIKit

private let reuseIdentifier = "EditProfileCell"

class EditProfileController: UITableViewController, EditProfileHeaderDelegate {
    
    
    func handleChangeProfilePhoto() {
        print("DEBUG: change photo tapped")
    }
    
    //MARK: - Properties
    
    private let user: User
    
    private lazy var headerView = EditProfileHeader(user: user) // lazy because we use user property
    
    
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        configureNavigationBar()
        configureTableView()
    }
    
    //MARK: - Selectors
    
    @objc func didTapCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapDone() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - API
    
    //MARK: - Helpers
    
    private func configureNavigationBar() {
    if #available(iOS 15.0, *) {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .twitterBlue
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
     
    } else {
    navigationController?.navigationBar.barTintColor = .twitterBlue
    }
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.isTranslucent = false
     
    navigationItem.title = "Edit Profile"
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
    navigationItem.rightBarButtonItem?.isEnabled = false
    }
    func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        tableView.tableFooterView = UIView()  // eliminates extra separating lines
        headerView.delegate = self 
    }
}

extension EditProfileController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EditProfileCell
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return cell }
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return 0 }
        return option == .bio ? 100 : 48
    }
}


