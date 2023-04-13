//
//  EditProfileController.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 14.03.2023.
//

import UIKit

private let reuseIdentifier = "EditProfileCell"

protocol EditProfileControllerDelegate: class {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
}

class EditProfileController: UITableViewController, EditProfileHeaderDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    //MARK: - Properties
    
    weak var delegate: EditProfileControllerDelegate?
    
    private var user: User
    private let imagePicker = UIImagePickerController()
    private lazy var headerView = EditProfileHeader(user: user)
    
    private var imageChanged: Bool {
        return selectedImage != nil
    }
    
    private var selectedImage: UIImage? {
        didSet {
            headerView.profileImageView.image = selectedImage
        }
    }
    
    private var userInflChanged = false
    
    
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
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        configureNavigationBar()
        configureTableView()
    }
    
    //MARK: - Selectors
    
    @objc func didTapCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapDone() {
        view.endEditing(true )
        guard imageChanged || userInflChanged else { return }
        updateUserData()
    }
    
    //MARK: - API
    
    func updateUserData() {
        if imageChanged && !userInflChanged {
            updateProfileImage()
        }
        
        if userInflChanged && !imageChanged {
            UserService.shared.safeUserData(for: user) { err, ref in
                self.delegate?.controller(self, wantsToUpdate: self.user)
            }
        }
        
        if userInflChanged && imageChanged {
            UserService.shared.safeUserData(for: user) { err, ref in
                self.updateProfileImage()
            }
        }
    }
    
    func updateProfileImage() {
        guard let image = selectedImage else { return }
        UserService.shared.updateProfileImage(image: image) { url in
            self.user.profileImageUrl = url
            self.delegate?.controller(self, wantsToUpdate: self.user)
        }
    }
    
    //MARK: - Helpers
    
    func handleChangeProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.selectedImage = image
        dismiss(animated: true,completion: nil)
    }
    
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
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        tableView.tableFooterView = UIView()  // eliminates extra separating lines
        headerView.delegate = self
    }
}

//MARK: - UITableViewDelegate

extension EditProfileController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EditProfileCell
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return cell }
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        cell.delegate = self
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

//MARK: - EditProfileCellDelegate

extension EditProfileController: EditProfileCellDelegate {
    func updateUserInfo(_ cell: EditProfileCell) {
        userInflChanged = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        guard let viewModel = cell.viewModel else { return }
        
        switch viewModel.option {
        case .fullname:
            guard let fullname = cell.infoTextfield.text else { return }
            user.fullName = fullname
        case .username:
            guard let username = cell.infoTextfield.text else { return }
            user.userName = username
        case .bio:
            user.bio = cell.bioTextView.text
            
        }
    }
}


