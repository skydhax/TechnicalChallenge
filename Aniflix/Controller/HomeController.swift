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
    
    let sliderCellId = "animeSliderCellId"
    let itemCellId = "animeCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setupTableView()
        setupNavbar()
    }
    
    
    
    private func setupNavbar() {
        title = "Aniflix"
    }
    
    private func fetchData() {
        
        SVProgressHUD.show(withStatus: "Loading series")
        ApiService.sharedInstance.callWSAuthAccessToken { (success:Bool, accessToken:String?) in
            if success, let at = accessToken {
                self.fetchAnimeData(at)
            }
        }
    }
    
    private func fetchAnimeData(_ accessToken:String) {
        ApiService.sharedInstance.callWSBrowseAnime(accessToken) { (success, animeArr) in
            if success {
                var animeTv = [Anime]()
                var animeMovie = [Anime]()
                var animeOva = [Anime]()
                for ani in animeArr! {
                    if ani.type == "TV" {
                        animeTv.append(ani)
                    } else if ani.type == "Movie" {
                        animeMovie.append(ani)
                    } else {
                        animeOva.append(ani)
                    }
                }
                self.animes.append(animeTv)
                self.animes.append(animeMovie)
                self.animes.append(animeOva)
                SVProgressHUD.dismiss()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
    
    
    var headers = ["TV Anime series","Movies","OVAs"]
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
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
        cell.anime = self.animes[collectionView.tag][indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selecting: \(collectionView.tag) - \(indexPath.item)")
    }
}

