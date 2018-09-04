//
//  MyGroupsController.swift
//  VKclient
//
//  Created by Никита Латышев on 24.08.2018.
//  Copyright © 2018 Никита Латышев. All rights reserved.
//

import UIKit

class MyGroupsController: UITableViewController {
var myGroupsList: [Groups] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
loadData()

    }

    func loadData() {
        let service = Service()
        service.getGroupsList { (groups, error) in
            // TODO: обработка ошибок
            if let error = error {
                print(error)
                return
            }
            // получили список групп
            if let groups = groups {
                self.myGroupsList = groups
                // обновить tableView
                self.tableView?.reloadData()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGroupsList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupCell", for: indexPath) as! MyGroupsCell
        
        let group = myGroupsList[indexPath.row]
        tableView.rowHeight = group.cellHeight
        let url = URL(string: group.photo)
        cell.setName(text: group.groupName)
        cell.imageGroup.kf.setImage(with: url)
        cell.nameGroup.text = group.groupName
        if group.cellHeight == 0.0 {
            group.cellHeight = cell.getCellHeight()
        }
        return cell
    }
    // Удаление группы
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myGroupsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}
