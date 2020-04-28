//
//  PostView.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 06/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

// View that displays a post of a topic.
class PostView: UIView {

    // MARK: - View Outlet
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var nicknameView: UIView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!

    // MARK: - View Properties
    var userId: String?

    // =====================
    // MARK: - View Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        tapGestureRecognizer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        tapGestureRecognizer()
    }

    // The init of the view from the nib.
    private func commonInit() {
        Bundle.main.loadNibNamed("PostView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

        nicknameView.backgroundColor = UIColor.orange.withAlphaComponent(0.1)
        textView.isEditable = false
        textView.isScrollEnabled = false

        contentView.layer.borderColor = UIColor.darkGray.cgColor
        contentView.layer.borderWidth = 0.25
    }

    // ======================
    // MARK: - View Functions

    /// Function that adds a tapGestureRecognizer to the nicknameLabel.
    private func tapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showUserAccount))
        nicknameLabel.addGestureRecognizer(tapGesture)
    }

    /// Function that sends a notification to tell when the nicknameLabel is tapped.
    @objc func showUserAccount() {
        guard let userID = userId else { return }
        let userIdDict: [String: String] = ["userId": userID]
        let notifName = NSNotification.Name("NicknameTapped")
        NotificationCenter.default.post(name: notifName, object: nil, userInfo: userIdDict)
    }

    /**
     Function that configures the PostView.

     Calling this function gets the user nickname from the db, gives a value to the textView,
     and displays the date of the post.
     
     - Parameter post: The post to display.
     */
    func configure(post: Post) {
        userId = post.userId
        UsersService.getUserNickname(userId: post.userId) { (nickname) in
            self.nicknameLabel.text = nickname
        }
        dateLabel.text = "Posté le \(DateService().transformDateToString(date: post.date)) à \(DateService().transformHourToString(date: post.date))"
        textView.text = post.text
    }
}
