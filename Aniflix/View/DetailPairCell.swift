//
//  DetailPairCell.swift
//  Aniflix
//
//  Created by Daniel Reyes Sánchez on 04/11/17.
//  Copyright © 2017 Daniel Reyes Sánchez. All rights reserved.
//

import UIKit

class DetailPairCell:UITableViewCell {
    
    var property:[String:String]? {
        didSet {
            guard let property = property else {return}
            keyLabel.text = property.keys.first
            valueLabel.text = property.values.first
        }
    }
    
    let keyLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .lightGray
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    let valueLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(keyLabel)
        addSubview(valueLabel)
        
        keyLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingRight: 0, paddingBottom: 0, width: self.frame.width/3, height: 0)
        valueLabel.anchor(top: topAnchor, left: keyLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 16, paddingRight: 8, paddingBottom: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

