//
//  Urls.swift
//  Aniflix
//
//  Created by Daniel Reyes Sánchez on 04/11/17.
//  Copyright © 2017 Daniel Reyes Sánchez. All rights reserved.
//

import Foundation

class Urls {
    private static let base = "https://anilist.co/api/"
    static let authAccessToken = base + "auth/access_token"
    static let browseAnime = base + "browse/anime/"
    static let getAnimeDetails = base + "anime/" //anime/{id}/page
}
