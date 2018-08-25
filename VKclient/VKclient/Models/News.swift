//
//  News.swift
//  VKclient
//
//  Created by Никита Латышев on 25.08.2018.
//  Copyright © 2018 Никита Латышев. All rights reserved.
//

import Foundation
import SwiftyJSON

class News {
    var textNews: String = ""
    var like: String = ""
    var comments: String = ""
    var repost: String = ""
    var view: String = ""
    var type: String = ""
    var newsImage: String = ""
    var author: String = ""
    var sourceId: Int = 0
    var avatar: String = ""
    var attachments: PhotoNews? = nil
    var photos: PhotoNews? = nil
    var cellHeight: CGFloat = 0.0
    
    init (json: JSON) {
        self.textNews = json["text"].stringValue
        self.like = json["likes"]["count"].stringValue
        self.comments = json["comments"]["count"].stringValue
        self.repost = json["reposts"]["count"].stringValue
        self.view = json["views"]["count"].stringValue
        self.sourceId = json["source_id"].intValue
        self.type = json["type"].stringValue
        self.newsImage = json["attachments"][0]["photo"]["sizes"][0]["url"].stringValue
        self.author = json["groups"][0]["name"].stringValue
        
        if type == "post" {
            if json["attachments"].count > 0, json["attachments"][0]["photo"]["sizes"].count > 0  {
                let attachment = json["attachments"][0]["photo"]["sizes"].arrayValue.filter({ $0["type"] == "x" })
                self.attachments = PhotoNews(json: attachment[0])
            }
        } else if type == "photo" {
            print("photo")
            let photos = json["photos"]["items"][0]["sizes"].arrayValue.filter({ $0["type"] == "x" })
            self.photos = PhotoNews(json: photos[0])
        }
    }
}

