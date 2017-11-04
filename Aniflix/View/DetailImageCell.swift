//
//  DetailButtonCell.swift
//  Aniflix
//
//  Created by Daniel Reyes Sánchez on 04/11/17.
//  Copyright © 2017 Daniel Reyes Sánchez. All rights reserved.
//

import UIKit

class DetailImageCell: UITableViewCell {
    
    var character:Character? {
        didSet {
            guard let character = character else {return}
            customImageView.loadImage(from: character.image_url_med)
            let fullName = character.name_first + " " + (character.name_last ?? "")
            
            let attributedText = NSMutableAttributedString(string: fullName, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17)])
            if let role = character.role {
                attributedText.append(NSAttributedString(string: "\n\(role) character", attributes: [NSAttributedStringKey.font  : UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor : UIColor.gray]))
            }
            
            titleLabel.attributedText = attributedText
        }
    }
    
    let customImageView:CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(customImageView)
        addSubview(titleLabel)
        
        customImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingRight: 0, paddingBottom: 0, width: 150, height: 150)
        customImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        
        titleLabel.anchor(top: topAnchor, left: customImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 16, paddingRight: 16, paddingBottom: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
