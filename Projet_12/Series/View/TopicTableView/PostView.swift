//
//  PostView.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 06/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class PostView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var nicknameView: UIView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
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
    
    func configure(post: Post) {
        UsersService.getUserNickname(userId: post.userId) { (nickname) in
            self.nicknameLabel.text = nickname
        }
        dateLabel.text = "\(post.date)"
        textView.text = post.text
    }
}
