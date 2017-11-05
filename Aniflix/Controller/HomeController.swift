//
//  HomeController.swift
//  Aniflix
//
//  Created by Daniel Reyes Sánchez on 04/11/17.
//  Copyright © 2017 Daniel Reyes Sánchez. All rights reserved.
//

import UIKit
import SVProgressHUD



class HomeController:UITableViewController {
    
    var animes = [[Anime]]()
    var accessToken = ""
    
    let sliderCellId = "animeSliderCellId"
    let itemCellId = "animeCellId"
    
    var types = ["TV","TV Short","Movie","Special","OVA","ONA","Music"]
    
    lazy var searchController:UISearchController = {
        let resultsController = SearchResultsController(style: .grouped)
        let searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = resultsController // resultsController now is responsible for UISearchResultsUpdating Delegate
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true // This line keeps the Searchbar visible in iOS 11
        return searchController
    }()
    
    let selectAnimeNotification = Notification.Name("com.skylabs.Aniflix.selectAnime")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setupTableView()
        setupNavbar()
        setupObserver()
    }
    
    
    private func setupNavbar() {
        title = "Aniflix"
        
        if #available(iOS 11, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController = searchController
        } else {
            self.tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectAnime(notification:)), name: selectAnimeNotification, object: nil)
    }
    
    @objc public func didSelectAnime(notification:Notification) {
        self.searchController.isActive = false
        guard let id = notification.object as? Int else {return}
        showDetailsViewController(with: id)
    }
    
    private func showDetailsViewController(with animeId:Int) {
        let vc = DetailController(style: .plain)
        vc.animeId = animeId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func fetchData() {
        SVProgressHUD.show(withStatus: "Loading series")
        ApiService.sharedInstance.callWSAuthAccessToken { (success:Bool, accessToken:String?) in
            if success, let at = accessToken {
                for i in 0...self.types.count - 1 {
                    self.animes.append([])
                    self.fetchAnimeDataWith(at, 1, self.types[i])
                    self.insertionTypes[self.types[i]] = i
                }
            } else {
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "An error ocurred, please try later")
            }
        }
    }
    
    var animesTV = [Anime]()
    var insertionTypes = [String:Int]()
    
    private func fetchAnimeDataWith(_ accessToken:String, _ page:Int, _ type:String) {
        self.accessToken = accessToken
        ApiService.sharedInstance.callWSBrowseAnime(accessToken,page,type) { (success, animeArr) in
            if success {
                guard let i = self.insertionTypes[type] else {return}
                self.animes[i] = self.animes[i] + animeArr!
                SVProgressHUD.dismiss()
                DispatchQueue.main.async {
                    let contentOffset = self.tableView.contentOffset
                    self.tableView.reloadData()
                    self.tableView.layoutIfNeeded()
                    self.tableView.setContentOffset(contentOffset, animated: false)
                }
            }
        }
    }
    
    
    
    private func setupTableView() {
        tableView.register(AnimeSliderCell.self , forCellReuseIdentifier: sliderCellId)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return animes.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return types[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: sliderCellId, for: indexPath) as! AnimeSliderCell
        return cell
    }
    
    
    
}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? AnimeSliderCell else {return}
        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self , forSection: indexPath.section)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animes[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellId, for: indexPath) as! AnimeCell
        if indexPath.item == self.animes[collectionView.tag].count - 1 {
            let nextPage = self.animes[collectionView.tag].count / 40 + 1
            self.fetchAnimeDataWith(self.accessToken, nextPage, types[collectionView.tag])
        }
        cell.anime = self.animes[collectionView.tag][indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showDetailsViewController(with: self.animes[collectionView.tag][indexPath.item].id)
    }
}


