//
//  NewsController.swift
//  VKclient
//
//  Created by Никита Латышев on 24.08.2018.
//  Copyright © 2018 Никита Латышев. All rights reserved.
//

import UIKit
import Kingfisher

class NewsController: UITableViewController {
    var newsList: [News] = []
    var imageSize: (width: Int, height: Int) = (0, 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    // Получаем новости
    func loadData() {
        let service = Service()
        service.getNewsFeed() { (news, error) in
            // TODO: обработка ошибок
            if let error = error {
                print(error)
                return
            }
            // получили массив новостей
            if let news = news {
                self.newsList = news
                // обновить tableView
                self.tableView?.reloadData()
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Получаем новость
        let newsItem = newsList[indexPath.row]
        if newsItem.type == "post" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsCellIdentifier", for: indexPath) as! NewsCell
            tableView.rowHeight = newsItem.cellHeight
            let avatar = URL(string: newsItem.avatar)
            cell.avatarImage.kf.setImage(with: avatar)
            cell.setAuthor(text: newsItem.author)
            cell.setTextNews(text: newsItem.textNews)
            cell.setLike(text: newsItem.like)
            cell.setComment(text: newsItem.comments)
            cell.setRepost(text: newsItem.repost)
            cell.setView(text: newsItem.view)
            cell.attachments(news: newsItem, cell: cell, indexPath: indexPath, tableView: tableView)
            if newsItem.cellHeight == 0.0 {
                newsItem.cellHeight = cell.getCellHeight()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsPhotoCellIdentifier", for: indexPath) as! NewsPhotoCell
            tableView.rowHeight = newsItem.cellHeight
            let avatar = URL(string: newsItem.avatar)
            let image = URL(string: newsItem.newsImage)
            
            cell.avatarPhoto.kf.setImage(with: avatar)
            cell.setAuthor(text: newsItem.author)
            cell.setStatistics(news: newsItem)
            
            if let photo = newsItem.photos {
                imageSize = (photo.width, photo.height)
                cell.imagePhoto.kf.setImage(with: image)
            } else {
                imageSize = (0, 0)
            }
            
            if newsItem.cellHeight == 0.0 {
                newsItem.cellHeight = cell.getCellHeight()
            }
            return cell
        }
    }
}
