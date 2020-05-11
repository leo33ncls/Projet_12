//
//  FavoriteTopicView.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 31/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

// View that displays favorite topic informations.
class FavoriteTopicView: UIView {

    // MARK: - View Outlet
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var serieNameLabel: UILabel!
    @IBOutlet weak var topicTitleLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    // ====================
    // MARK: - View Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // The init of the view from the nib.
    private func commonInit() {
        Bundle.main.loadNibNamed("FavoriteTopicView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }

    // =======================
    // MARK: - View Functions

    /**
     Function that configures the FavoriteTopicView.

     Calling this function gives a value to the serieNameLabel and the topicTitleLabel;
     gets the user nickname, and displays the creation date of the topic.
     
     - Parameters:
        - favoriteTopic: The favorite topic to display.
        - indexPath: The indexPath of the cell.
     */
    func configure(favoriteTopic: Topic, indexPath: Int) {
        serieNameLabel.text = favoriteTopic.serieName
        topicTitleLabel.text = favoriteTopic.title
        UsersService.getUserNickname(userId: favoriteTopic.userId) { (nickname) in
            if let nickname = nickname {
                self.nicknameLabel.text = nickname
            } else {
                self.nicknameLabel.text = NSLocalizedString("ACCOUNT_DELECTED", comment: "")
            }
        }
        if Calendar.current.isDate(Date(), inSameDayAs: favoriteTopic.date) {
            dateLabel.text = DateService().transformHourToString(date: favoriteTopic.date)
        } else {
            dateLabel.text = DateService().transformDateToString(date: favoriteTopic.date)
        }

        if indexPath % 2 == 0 {
            contentView.backgroundColor = UIColor.orange.withAlphaComponent(0.1)
        }
    }
}
