//
//  FavoriteTopicView.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 31/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class FavoriteTopicView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var serieNameLabel: UILabel!
    @IBOutlet weak var topicTitleLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FavoriteTopicView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }

    func configure(favoriteTopic: Topic, indexPath: Int) {
        serieNameLabel.text = String(favoriteTopic.serieId)
        topicTitleLabel.text = favoriteTopic.title
        UsersService.getUserNickname(userId: favoriteTopic.userId) { (nickname) in
            self.nicknameLabel.text = nickname
        }
        if Calendar.current.isDate(Date(), inSameDayAs: favoriteTopic.date) {
            dateLabel.text = displayHour(date: favoriteTopic.date)
        } else {
            dateLabel.text = displayDate(date: favoriteTopic.date)
        }
        
        if indexPath % 2 == 0 {
            contentView.backgroundColor = UIColor.orange.withAlphaComponent(0.1)
            contentView.layer.borderWidth = 0.25
            contentView.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    private func displayDate(date: Date) -> String {
        let day = Calendar.current.component(.day, from: date)
        let month = Calendar.current.component(.month, from: date)
        
        if day < 10 && month < 10 {
            return "0\(day)/0\(month)"
        } else if day < 10 {
            return "0\(day)/\(month)"
        } else if month < 10 {
            return "\(day)/0\(month)"
        } else {
            return "\(day)/\(month)"
        }
    }
    
    private func displayHour(date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        
        if hour < 10 && minute < 10 {
            return "0\(hour):0\(minute)"
        } else if hour < 10 {
            return "0\(hour):\(minute)"
        } else if minute < 10 {
            return "\(hour):0\(minute)"
        } else {
            return "\(hour):\(minute)"
        }
    }
}
