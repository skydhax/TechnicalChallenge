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
    
    
    //browse/anime?page={page}&type={type}
    func callWSBrowseAnime( _ accessToken:String, _ page:Int, _ type:String ,_ completion: @escaping (Bool,[Anime]?) -> () ) {
        guard let escapedType = type.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        let body = "?page=\(page)&type=\(escapedType)"
        let url = URL(string: Urls.browseAnime + body)!
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["Authorization": "Bearer \(accessToken)"]
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.httpBody = body.data(using: .utf8)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        session.dataTask(with: request, completionHandler: {(data, response, error) in
            guard error == nil else {
                completion(false,nil)
                return
            }
//            if let returnData = String(data: data!, encoding: .utf8) {
//                print(returnData)
//            }
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
    
    func callWSGetAnimeDetails( _ accessToken:String, _ id:Int ,_ completion: @escaping (Bool,Anime?) -> () ) {
        let url = URL(string: Urls.animeRoute + "\(id)/page")! // anime/{id}/page
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
//            if let returnData = String(data: data!, encoding: .utf8) {
//                print(returnData)
//            }
            if let unwrappedData = data {
                do {
                    let anime = try JSONDecoder().decode(Anime.self , from: unwrappedData)
                    completion(true,anime)
                } catch let err {
                    print(err.localizedDescription)
                }
            }
        }).resume()
    }
    
    
    func callWSSearchAnime( _ accessToken:String, _ query:String ,_ completion: @escaping (Bool,[Anime]?) -> () ) {
        guard let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        let url = URL(string: Urls.animeRoute + "search/\(escapedQuery)")! // anime/search/{query}
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
//          if let returnData = String(data: data!, encoding: .utf8) {
//                print(returnData)
//          }
            if let unwrappedData = data {
                do {
                    let anime = try JSONDecoder().decode([Anime].self , from: unwrappedData)
                    completion(true,anime)
                } catch let err {
                    print(err.localizedDescription)
                }
            }
        }).resume()
    }
    
}
