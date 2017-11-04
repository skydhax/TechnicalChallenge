//
//  CustomImageView.swift
//  Aniflix
//
//  Created by Daniel Reyes Sánchez on 04/11/17.
//  Copyright © 2017 Daniel Reyes Sánchez. All rights reserved.
//

import UIKit

var imageCache = [String:UIImage]()

class CustomImageView: UIImageView{
    
    var urlString:String?
    
    func loadImage(from urlString: String) {
        self.urlString = urlString
        self.image = nil
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
            if let err = error {
                print("Faled to fetch post image:",err.localizedDescription)
                return
            }
            if url.absoluteString != self.urlString {
                return
            }
            guard let imageData = data else {return}
            let image = UIImage(data: imageData)
            imageCache[url.absoluteString] = image
            DispatchQueue.main.async {
                self.image = image
            }
            }.resume()
    }
}
