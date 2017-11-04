//
//  Character.swift
//  Aniflix
//
//  Created by Daniel Reyes Sánchez on 04/11/17.
//  Copyright © 2017 Daniel Reyes Sánchez. All rights reserved.
//

import Foundation

class Character:Decodable {
    let id:Int?
    let name_first:String
    let name_last:String?
    let image_url_lge:String
    let image_url_med:String
    let role:String?
}
