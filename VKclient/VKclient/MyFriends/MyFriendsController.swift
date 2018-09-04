//
//  MyFriendsController.swift
//  VKclient
//
//  Created by Никита Латышев on 24.08.2018.
//  Copyright © 2018 Никита Латышев. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class MyFriendsController: UITableViewController {
    let realm = try! Realm()
    var friends: [Friends] = []
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromDatabase()
        loadFromNetwork()
        observeMyFriends()
    }
    
    // Получаем массив друзей из Realm
    func loadFromDatabase() {
        friends = Array(realm.objects(Friends.self))
        tableView.reloadData()
    }
    
    func loadFromNetwork() {
        let service = Service()
        service.getFriendList() { (error) in
            if let error = error {
                // TODO: handle error
                print(error)
                return
            }
            
            self.loadFromDatabase()
        }
    }
    
    // Подключаем Notification
    func observeMyFriends() {
        let friends = realm.objects(Friends.self)
        notificationToken = friends.observe { (changes) in
            guard let tableView = self.tableView else {return}
            switch changes {
            case .initial:
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.endUpdates()
                break
            case .error(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let FriendsPhotoController = segue.destination as? FriendsPhotoController {
            if let indexPath = tableView.indexPathForSelectedRow {
                // передаем id друга в FriendsPhotoController
                FriendsPhotoController.friend = friends[indexPath.row]
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = friends[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriends", for: indexPath) as! MyFriendsCell
        tableView.rowHeight = friend.cellHeight
        let url = URL(string: friend.photo)
        cell.setName(text: friend.firstName + " " + friend.lastName)
        cell.avatar.kf.setImage(with: url)
        if friend.cellHeight == 0.0 {
            friend.cellHeight = cell.getCellHeight()
        }
        return cell
    }
    
}
