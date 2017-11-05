//
//  DetailController.swift
//  Aniflix
//
//  Created by Daniel Reyes Sánchez on 04/11/17.
//  Copyright © 2017 Daniel Reyes Sánchez. All rights reserved.
//

import UIKit
import SVProgressHUD

class DetailController:UITableViewController {
    
    
    var animeId:Int? {
        didSet {
            guard let id = animeId else {return}
            fetchData(id)
        }
    }
    
    var anime:Anime?
    
    let detailPairCellId = "detailPairCellId"
    let descriptionCellId = "descriptionCellId"
    let headerCellId = "headerCellId"
    let imageCellId = "imageCellId"
    
    
    var properties = [[String:String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
    }
    
    private func fetchData(_ id:Int) {
        SVProgressHUD.show(withStatus: "Loading series")
        ApiService.sharedInstance.callWSAuthAccessToken { (success:Bool, accessToken:String?) in
            if success, let at = accessToken {
                self.fetchAnimeDetails(at, id)
            }
        }
    }
    
    private func fetchAnimeDetails(_ accessToken:String, _ id:Int) {
        ApiService.sharedInstance.callWSGetAnimeDetails(accessToken, id) { (success , anime) in
            if success {
                self.anime = anime!
                self.setupData(anime!)
                SVProgressHUD.dismiss()
            } else {
                
            }
        }
    }
    
    private func setupData(_ anime:Anime) {
        properties.append(["English title":anime.title_english])
        properties.append(["Original title":anime.title_japanese])
        properties.append(["Romanji title":anime.title_romaji])
        properties.append(["Total Episodes": "\(anime.total_episodes)"])
        properties.append(["Average Score": "\(anime.average_score)"])
        properties.append(["Type":anime.type])
        properties.append(["Adult": (anime.adult ? "Yes" : "No") ])
        properties.append(["Airing Status": anime.airing_status ?? "Unknown"])
        if let d = anime.start_date_fuzzy {
            properties.append(["Start date":fussyDateToString(d)])
        }
        if let d = anime.end_date_fuzzy {
            properties.append(["End date":fussyDateToString(d)])
        }
        if let s = anime.season {
            properties.append(["Season":"\(s)"])
        }
        DispatchQueue.main.async {
            self.title = anime.title_english
            self.tableView.reloadData()
        }
    }
    
    private func fussyDateToString(_ d:Int) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.date(from: "\(d)")!
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func setupTableView() {
        tableView.estimatedRowHeight = 500
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(DetailHeaderCell.self , forCellReuseIdentifier: headerCellId)
        tableView.register(DetailDescriptionCell.self, forCellReuseIdentifier: descriptionCellId)
        tableView.register(DetailPairCell.self , forCellReuseIdentifier: detailPairCellId)
        tableView.register(DetailImageCell.self , forCellReuseIdentifier: imageCellId)
    }
    
    // MARK: - TableView Delegate methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (anime != nil ? 4 : 0)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else if section == 3 {
            return anime?.characters?.count ?? 0
        }
        return properties.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 3 {
            return "Characters"
        }
        return nil
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.view.frame.height/2
        } else if indexPath.section == 1 {
            return UITableViewAutomaticDimension
        } else if indexPath.section == 3 {
            return 175
        }
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return headerCell(tableView,indexPath)
        } else if indexPath.section == 1{
            return descriptionCell(tableView,indexPath)
        } else if indexPath.section == 2{
            return detailCell(tableView,indexPath)
        } else {
            return characterCell(tableView,indexPath)
        }
    }
    
    // MARK: - Cells
    
    func headerCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: headerCellId, for: indexPath) as! DetailHeaderCell
        if let banner = anime?.image_url_banner {
            cell.headerImageView.loadImage(from: banner)
        } else {
            cell.headerImageView.loadImage(from: anime!.image_url_lge)
        }
        return cell
    }
    
    func descriptionCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellId, for: indexPath) as! DetailDescriptionCell
        cell.detailLabel.text = anime?.description?.replacingOccurrences(of: "<br>", with: "\n")
        return cell
    }
    
    func detailCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: detailPairCellId, for: indexPath) as! DetailPairCell
        cell.property = properties[indexPath.row]
        return cell
    }

    func characterCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: imageCellId, for: indexPath) as! DetailImageCell
        cell.character = self.anime?.characters?[indexPath.row]
        return cell
    }
    
    
}