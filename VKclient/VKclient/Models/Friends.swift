//
//  Friends.swift
//  VKclient
//
//  Created by Никита Латышев on 28.08.2018.
//  Copyright © 2018 Никита Латышев. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Friends: Object {
    
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var photo: String = ""
    @objc dynamic var nickname: String = ""
    var cellHeight: CGFloat = 0.0
    
    convenience init(json: JSON) {
        self.init()
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.id = json["id"].intValue
        self.photo = json["photo_200_orig"].stringValue
    }
}
