//
//  Photo.swift
//  VKclient
//
//  Created by Никита Латышев on 29.08.2018.
//  Copyright © 2018 Никита Латышев. All rights reserved.
//

import Foundation
import SwiftyJSON

class Photo {
    var photo: String = ""
    
    init(json: JSON) {
        self.photo = json[json.count - 1]["url"].stringValue
    }
}
