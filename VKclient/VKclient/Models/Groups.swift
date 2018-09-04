//
//  Groups.swift
//  VKclient
//
//  Created by Никита Латышев on 03.09.2018.
//  Copyright © 2018 Никита Латышев. All rights reserved.
//

import Foundation
import SwiftyJSON

class Groups {
    var groupName: String = ""
    var membersCount: Int = 0
    var photo: String = ""
    var cellHeight: CGFloat = 0.0
    
    init(json: JSON) {
        self.groupName = json["name"].stringValue
        self.membersCount = json["members_count"].intValue
        self.photo = json["photo_100"].stringValue
    }
}
