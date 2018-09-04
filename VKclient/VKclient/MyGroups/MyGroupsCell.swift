//
//  MyGroupsCell.swift
//  VKclient
//
//  Created by Никита Латышев on 24.08.2018.
//  Copyright © 2018 Никита Латышев. All rights reserved.
//

import UIKit

class MyGroupsCell: UITableViewCell {

    @IBAction func addGroup(segue:UIStoryboardSegue){
        
        if segue.identifier == "addGroup" {
            let groupsListController = segue.source as! GroupListController
            
            if let indexPath = groupsListController.tableView.indexPathForSelectedRow {
                let group = groupsListController.myGroupsList[indexPath.row]
                groupsListController.myGroupsList.append(group)
                groupsListController.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var nameGroup: UILabel!{
        didSet {
            nameGroup.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var imageGroup: UIImageView!{
        didSet {
            imageGroup.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    let instets: CGFloat = 10.0
    var imageSize: (width: Int, height: Int) = (0, 0)
    let iconSideLinght: CGFloat = 62
    
    func getCellHeight() -> CGFloat {
        var height: CGFloat = 0.0
        height = 2 * instets + iconSideLinght
        return height
    }
    
    func setName (text: String){
        nameGroup.text = text
        name ()
    }
    
    func groupImage () {
        let iconSize = CGSize(width: iconSideLinght, height: iconSideLinght)
        let iconOrigin = CGPoint(x: bounds.midX * 0.05, y: instets)
        imageGroup.frame = CGRect(origin: iconOrigin, size: iconSize)
        
        // закругленные углы
        imageGroup.layer.cornerRadius = imageGroup.frame.size.width / 2
        imageGroup.clipsToBounds = true
    }
    
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        // максимальная ширина текста
        let maxWidth = bounds.width - instets * 2
        // размеры блока (макс. ширина и макс. возможная высота)
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        // прямоугольник под текст
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        // ширина и высота блока
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        // размер, округленный до большего целого
        let size = CGSize(width: ceil(width), height: ceil(height))
        
        return size
    }
    
    // Установка размеров и позиции названия группы
    func name () {
        let name = getLabelSize(text: nameGroup.text!, font: nameGroup.font)
        let nameX = bounds.width * 0.05 + 62 + bounds.width * 0.05
        let nameY = instets * 3
        let textOrigin = CGPoint(x: nameX, y: nameY)
        nameGroup.frame = CGRect(origin: textOrigin, size: name)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        name ()
        groupImage ()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
