//
//  TopicCellView.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 05/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

// View that displays topic informations.
class TopicCellView: UIView {

    // MARK: - View Outlet
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
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
        Bundle.main.loadNibNamed("TopicCellView", owner: self, options: nil)
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
     Function that configures the TopicCellView.

     Calling this function gives a value to the titleLabel, gets the user nickname,
     and displays the creation date of the topic.
     
     - Parameters:
        - topic: The topic to display.
        - indexPath: The indexPath of the cell.
     */
    func configure(topic: Topic, indexPath: Int) {
        titleLabel.text = topic.title
        UsersService.getUserNickname(userId: topic.userId) { (nickname) in
            if let nickname = nickname {
                self.nicknameLabel.text = nickname
            } else {
                self.nicknameLabel.text = NSLocalizedString("ACCOUNT_DELECTED", comment: "")
            }
        }
        if Calendar.current.isDate(Date(), inSameDayAs: topic.date) {
            dateLabel.text = DateService().transformHourToString(date: topic.date)
        } else {
            dateLabel.text = DateService().transformDateToString(date: topic.date)
        }

        if indexPath % 2 == 0 {
            contentView.backgroundColor = UIColor.orange.withAlphaComponent(0.1)
        }
    }
}
