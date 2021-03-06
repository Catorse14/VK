//
//  Service.swift
//  VKclient
//
//  Created by Никита Латышев on 25.08.2018.
//  Copyright © 2018 Никита Латышев. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

let api: String = "https://api.vk.com/method/"

struct VkPaths {
    let getFriends: String = "\(api)friends.get"
    let getPhotos: String = "\(api)photos.getAll"
    let getGroups: String = "\(api)groups.get"
    let groupsSearch: String = "\(api)groups.search"
    let getGroupsById: String = "\(api)groups.getById"
    let newsFeed: String = "\(api)newsfeed.get"
}

class Service: Operation {
    let api = VkPaths()
    var parameters: Dictionary<String, Any> = [:]
    let realm = try! Realm()
    
    init(token: String? = nil) {
        
        // Получаем токен
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            fatalError()
        }
        print(token)
        // Задаем параметры по-умолчанию для запросов
        parameters = [
            "access_token": token
        ]
    }
    
    // Получаем ленту новостей
    func getNewsFeed (completion: (([News]?, Error?) -> Void)?) {
        let parameters = [
            "filters": "post,photo",
            "return_banned": "0",
            "v": "5.80"
        ]
        let mergedParams = self.parameters.merged(another: parameters)
        
        DispatchQueue.global().async {
            Alamofire.request(self.api.newsFeed, parameters: mergedParams).responseJSON(queue:DispatchQueue.global()) { (response) in
                //                print(response)
                if let error = response.error {
                    print(error)
                    DispatchQueue.main.async {
                        completion?(nil, error)
                    }
                    return
                }
                if let value = response.data {
                    if let json = try? JSON(data: value) {
                        let news = json["response"]["items"].arrayValue.map {News (json: $0) }
                        let newsProfiles = json["response"]["profiles"].arrayValue
                        let newsGroups = json["response"]["groups"].arrayValue
                        
                        // добавляем в news аватар и имя автора
                        for item in news {
                            if item.sourceId > 0 {
                                
                                // берем данные из профиля пользователя (секция profiles)
                                let profile = newsProfiles.filter({ $0["id"].intValue == item.sourceId })
                                item.avatar = profile[0]["photo_50"].stringValue
                                item.author = profile[0]["first_name"].stringValue + " " + profile[0]["last_name"].stringValue
                            } else {
                                
                                // или берем данные из профиля группы (секция groups)
                                let group = newsGroups.filter({ $0["id"].intValue == abs(item.sourceId) })
                                item.avatar = group[0]["photo_50"].stringValue
                                item.author = group[0]["name"].stringValue
                            }
                        }
                        DispatchQueue.main.async {
                            completion?(news, nil)
                        }
                    }
                    return
                }
            }
        }
    }
    
    // Получаем список друзей и сохраняем их в Realm
    func getFriendList(completion: ((Error?) -> Void)?) {
        let parameters = [
            "fields": "photo_200_orig",
            "name_case": "nom",
            "order": "name",
            "v": "5.80"
        ]
        let mergedParams = self.parameters.merged(another: parameters)
        
        DispatchQueue.global().async {
            Alamofire.request(self.api.getFriends, parameters: mergedParams).responseJSON { (response) in
                //                print(response)
                if let error = response.error {
                    completion?(error)
                    return
                }
                if let value = response.data, let json = try? JSON(data: value) {
                    let friends = json["response"]["items"].arrayValue.map { Friends(json: $0) }
                    self.saveToRealm(items: friends)
                    completion?(nil)
                }
                return
            }
        }
    }
    
    // Функция с дженериком, которая сохраняет данные в Realm
    func saveToRealm<T: Object>(items: [T]) {
        let realm = try! Realm()
        do {
            try realm.write {
                // Получаем объекты типа Т
                let itemsToRemove = realm.objects(T.self)
                // Удаляем старые объекты
                realm.delete(itemsToRemove)
                // Добавляем новые объекты
                realm.add(items)
            }
        } catch {
            print(error)
        }
    }
    
    // Получаем фото друга
    func getFriendPhotos(ownerId: Int, completion: (([Photo]?, Error?) -> Void)?) {
        let parameters = [
            "owner_id": ownerId,
            "v": "5.80",
            "extended": 1
            ] as [String : Any]
        
        let mergedParams = self.parameters.merged(another: parameters)
        
        DispatchQueue.global().async {
            Alamofire.request(self.api.getPhotos, parameters: mergedParams).responseJSON(queue:DispatchQueue.global()) { (response) in
                //                print (response)
                if let error = response.error {
                    completion?(nil, error)
                    return
                }
                
                if let value = response.data {
                    if let json = try? JSON(data: value) {
                        let photos = json["response"]["items"].arrayValue.map { Photo(json: $0["sizes"]) }
                        DispatchQueue.main.async {
                            completion?(photos, nil)
                        }
                    }
                    return
                }
            }
        }
    }
    
    //    Получаем список групп
    func getGroupsList(completion: (([Groups]?,Error?) -> Void)?) {
        let parameters = [
            "fields": "members_count",
            "extended": "1",
            "v": "5.80"
        ]
        
        let mergedParams = self.parameters.merged(another: parameters)
        
        DispatchQueue.global().async {
            Alamofire.request(self.api.getGroups, parameters: mergedParams).responseJSON(queue:DispatchQueue.global()) { (response) in
                if let error = response.error {
                    completion?(nil, error)
                    return
                }
                
                if let value = response.data {
                    if let json = try? JSON(data: value) {
                        let groups = json["response"]["items"].arrayValue.map { Groups(json: $0) }
                        DispatchQueue.main.async {
                            completion?(groups, nil)
                        }
                    }
                    return
                }
            }
        }
    }
}

extension Dictionary {
    func merged(another: [Key: Value]) -> Dictionary {
        var result: [Key: Value] = [:]
        for (key, value) in self {
            result[key] = value
        }
        for (key, value) in another {
            result[key] = value
        }
        return result
    }
}
