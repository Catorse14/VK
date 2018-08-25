//
//  PhotoNews.swift
//  VKclient
//
//  Created by Никита Латышев on 25.08.2018.
//  Copyright © 2018 Никита Латышев. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PhotoNews {
    var url: String = ""
    var width: Int = 0
    var height: Int = 0
    
    init(json: JSON) {
        self.url = json["url"].stringValue
        self.width = json["width"].intValue
        self.height = json["height"].intValue
    }
}
