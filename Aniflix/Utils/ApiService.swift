//
//  ApiService.swift
//  Aniflix
//
//  Created by Daniel Reyes Sánchez on 04/11/17.
//  Copyright © 2017 Daniel Reyes Sánchez. All rights reserved.
//

import Foundation

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    func callWSAuthAccessToken(_ completion: @escaping (Bool,String?) -> () ) {
        let url = URL(string: Urls.authAccessToken)!
        let body = "grant_type=client_credentials&client_id=skydhax-y8plv&client_secret=pnjp8XLeImfpsbhPnIZy"
        var request = URLRequest(url: url)
        request.httpBody = body.data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            guard error == nil else {
                completion(false,nil)
                return
            }
            if let returnData = String(data: data!, encoding: .utf8) {
                print(returnData)
            }
            do{
                if let unwrappedData = data, let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? NSDictionary {
                    if let accessToken = jsonDictionaries["access_token"] as? String {
                        completion(true,accessToken)
                    }
                }
            } catch let error {
                print(error)
                completion(false,nil)
            }
        }).resume()
    }
    
    
    func callWSBrowseAnime( _ accessToken:String ,_ completion: @escaping (Bool,[Anime]?) -> () ) {
        let url = URL(string: Urls.browseAnime)!
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["Authorization": "Bearer \(accessToken)"]
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        session.dataTask(with: request, completionHandler: {(data, response, error) in
            guard error == nil else {
                completion(false,nil)
                return
            }
            if let returnData = String(data: data!, encoding: .utf8) {
                print(returnData)
            }
            if let unwrappedData = data {
                do {
                    let animeArr = try JSONDecoder().decode([Anime].self , from: unwrappedData)
                    completion(true,animeArr)
                } catch let err {
                    print(err.localizedDescription)
                }
            }
        }).resume()
    }
    
}
