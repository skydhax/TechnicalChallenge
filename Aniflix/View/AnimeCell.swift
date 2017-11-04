//
//  AnimeCell.swift
//  Aniflix
//
//  Created by Daniel Reyes Sánchez on 04/11/17.
//  Copyright © 2017 Daniel Reyes Sánchez. All rights reserved.
//

import UIKit

class AnimeCell:UICollectionViewCell {
    
    var anime:Anime? {
        didSet {
            guard let anime = anime else {return}
            imageView.loadImage(from: anime.image_url_lge)
            
            let attributedText = NSMutableAttributedString(string: anime.title_english, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17)])
            attributedText.append(NSAttributedString(string: "\n★ \(anime.average_score/10)", attributes: [NSAttributedStringKey.font  : UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor : UIColor.black]))
            titleLabel.attributedText = attributedText
        }
    }
    
    let imageView:CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 15
        return iv
    }()
    
    let wrapperInfoView:UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(wrapperInfoView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 100, width: 0, height: 0)
        
        wrapperInfoView.addSubview(titleLabel)
        wrapperInfoView.anchor(top: imageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 100)
        titleLabel.anchor(top: wrapperInfoView.topAnchor, left: wrapperInfoView.leftAnchor, bottom: wrapperInfoView.bottomAnchor, right: wrapperInfoView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
