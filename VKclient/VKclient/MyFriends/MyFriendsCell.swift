//
//  MyFriendsCell.swift
//  VKclient
//
//  Created by Никита Латышев on 24.08.2018.
//  Copyright © 2018 Никита Латышев. All rights reserved.
//

import UIKit

class MyFriendsCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameFriend: UILabel!{
        didSet {
            nameFriend.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    let instets: CGFloat = 10.0
    var imageSize: (width: Int, height: Int) = (0, 0)
    let iconSideLinght: CGFloat = 62
    let statisticIcon: CGFloat = 25
    
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    func getCellHeight() -> CGFloat {
        var height: CGFloat = 0.0
        height = 2 * instets + iconSideLinght
        return height
    }
    
    func setName (text: String){
        nameFriend.text = text
        name ()
    }
    
    func avatarFriends () {
        let iconSize = CGSize(width: iconSideLinght, height: iconSideLinght)
        let iconOrigin = CGPoint(x: bounds.midX * 0.05, y: instets)
        avatar.frame = CGRect(origin: iconOrigin, size: iconSize)
        
        // закругленные углы
        avatar.layer.cornerRadius = avatar.frame.size.width / 2
        avatar.clipsToBounds = true
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
    
    // Установка размеров и позиции имени друга
    func name () {
        let name = getLabelSize(text: nameFriend.text!, font: nameFriend.font)
        let nameX = bounds.width * 0.05 + 62 + bounds.width * 0.05
        let nameY = instets * 3
        let textOrigin = CGPoint(x: nameX, y: nameY)
        nameFriend.frame = CGRect(origin: textOrigin, size: name)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        name ()
        avatarFriends ()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }

}
