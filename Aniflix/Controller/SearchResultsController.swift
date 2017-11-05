//
//  SearchResultsController.swift
//  Aniflix
//
//  Created by Daniel Reyes Sánchez on 05/11/17.
//  Copyright © 2017 Daniel Reyes Sánchez. All rights reserved.
//

import UIKit
import SVProgressHUD

class SearchResultsController: UITableViewController {
    
    var animes = [Anime]()
    var accessToken = ""
    
    let cellId = "cellId"
    
    let selectAnimeNotification = Notification.Name("com.skylabs.Aniflix.selectAnime")
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        fetchAccessToken()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UITableViewCell.self , forCellReuseIdentifier: cellId)
    }
    
    private func fetchAccessToken() {
        ApiService.sharedInstance.callWSAuthAccessToken { (success:Bool, accessToken:String?) in
            if success, let at = accessToken {
                self.accessToken = at
            }
        }
    }
    
    func searchAnime(_ accessToken:String, _ query:String) {
        ApiService.sharedInstance.callWSSearchAnime(accessToken,query) { (success , animes) in
            if success {
                self.animes = animes!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                SVProgressHUD.showError(withStatus: "An error ocurred, please try later")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = self.animes[indexPath.row].title_english
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true) {
            NotificationCenter.default.post(name: self.selectAnimeNotification, object: self.animes[indexPath.row].id)
        }
    }
    
}

extension SearchResultsController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, query != "", self.accessToken != "" else {return}
        self.searchAnime(self.accessToken, query)
    }
}
