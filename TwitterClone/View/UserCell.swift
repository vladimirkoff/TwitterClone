//
//  UserCell.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 04.03.2023.
//

import UIKit

protocol UserCellDelegate {
    func tweetClicked()
}

class UserCell: UITableViewCell {
    
    //MARK: - Properties
    
    var user: User? {
        didSet {
            configure()
        }
    }
    
    private lazy var profileImageView: UIImageView = {  // it must be lazy!
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 32, height: 32)
        iv.layer.cornerRadius = 32 / 2
        iv.backgroundColor = .twitterBlue
        
        return iv
    }()
    
    private let fullNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 20)
    label.text = "Vladimir Kovalev"
    return label
    }()
    
    private let userNamelabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .lightGray
    label.text = "@dfjknkv"

    return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {   // with table view cell
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [userNamelabel, fullNameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
        
    }
    
    func configure() {
        guard let user = user else { return }
        
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl))
        fullNameLabel.text = user.fullName
        userNamelabel.text = user.userName
    }
    
}
