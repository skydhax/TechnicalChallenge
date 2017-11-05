//
//  Anime.swift
//  Aniflix
//
//  Created by Daniel Reyes Sánchez on 04/11/17.
//  Copyright © 2017 Daniel Reyes Sánchez. All rights reserved.
//

import Foundation


class Anime:Decodable {
    let id:Int
    let title_romaji:String
    let title_english:String
    let title_japanese:String
    let type:String
    let start_date_fuzzy:Int?
    let end_date_fuzzy:Int?
    let season:Int?
    let description:String?
    let synonyms:[String]
    let genres:[String]
    let adult:Bool
    let average_score:Double
    let popularity:Int
    let image_url_sml:String
    let image_url_med:String
    let image_url_lge:String
    let image_url_banner:String?
    let updated_at:Int
    let score_distribution:[Int:Int]?
    
    // Anime model only values
    let total_episodes:Int
    let duration:Int?
    let characters:[Character]?
    let airing_status:String?
    let hashtag:String?
    let source:String?
}
