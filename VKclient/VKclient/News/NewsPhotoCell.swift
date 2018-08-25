//
//  NewsPhotoCell.swift
//  VKclient
//
//  Created by Никита Латышев on 25.08.2018.
//  Copyright © 2018 Никита Латышев. All rights reserved.
//

import UIKit

class NewsPhotoCell: UITableViewCell {
    @IBOutlet weak var statisticsBlockPhoto: UIView!{
        didSet {
            statisticsBlockPhoto.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var avatarPhoto: UIImageView!{
        didSet {
            avatarPhoto.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var viewPhoto: UILabel!
    @IBOutlet weak var repostPhoto: UILabel!
    @IBOutlet weak var commentsPhoto: UILabel!
    @IBOutlet weak var likePhoto: UILabel!
    @IBOutlet weak var imagePhoto: UIImageView!{
        didSet {
            imagePhoto.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var authorPhoto: UILabel!{
        didSet {
            authorPhoto.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    let instets: CGFloat = 10.0
    var imageSize: (width: Int, height: Int) = (0, 0)
    let iconSideLinght: CGFloat = 62
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    func setAuthor (text: String){
        authorPhoto.text = text
        author()
    }
    
    func setStatistics(news: News) {
        // лайки
        likePhoto.text = news.like
        
        //комментарии
        commentsPhoto.text = news.comments
        
        // репосты
        repostPhoto.text = news.repost
        
        //просмотры
        viewPhoto.text = news.view
        
        statisticsViewFrame()
    }
    
    func getCellHeight() -> CGFloat {
        var height: CGFloat = 0.0
        height += authorPhoto.frame.size.height + instets * 3
        height += instets * 3
        if imageSize != (0, 0) {
            height += 3 * instets}
        height += statisticsBlockPhoto.frame.size.height + 3 * instets
        return height
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
    
    func avatar () {
        let iconSize = CGSize(width: iconSideLinght, height: iconSideLinght)
        let iconOrigin = CGPoint(x: bounds.midX * 0.05, y: 23)
        avatarPhoto.frame = CGRect(origin: iconOrigin, size: iconSize)
    }
    
    // Установка размеров и позиции автора новости
    func author () {
        let author = getLabelSize(text: authorPhoto.text!, font: authorPhoto.font)
        let authorX = bounds.width * 0.05 + 62 + bounds.width * 0.05
        let authorY = instets * 3 - 7
        let textOrigin = CGPoint(x: authorX, y: authorY)
        authorPhoto.frame = CGRect(origin: textOrigin, size: author)
    }
    

    
    // Установка размеров и позиции изображения
    func imageViewFrame() {
        guard imageSize.width != 0, imageSize.height != 0 else {
            imagePhoto.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
            return
        }
        let ratio = Double(imageSize.height) / Double(imageSize.width)
        let y = avatarPhoto.frame.size.height + instets * 5
        let width = Double(bounds.width - instets * 2)
        let height = width * ratio
        let size = CGSize(width: width, height: ceil(height))
        let origin = CGPoint(x: instets, y: y)
        imagePhoto.frame = CGRect(origin: origin, size: size)
    }
    
    // Блок со статистикой
    func statisticsViewFrame() {
        let statisticsSize = CGSize(width: bounds.width - instets * 2, height: 60.0)
        var statisticsY = avatarPhoto.frame.size.height + instets * 2
        if imagePhoto.frame.size.height != 0.0 {
            statisticsY += imagePhoto.frame.size.height + instets
        }
        let statisticsOrigin = CGPoint(x: 0.0, y: statisticsY)
        statisticsBlockPhoto.frame = CGRect(origin: statisticsOrigin, size: statisticsSize)
    }
    
    func attachments (news: News, cell: NewsCell, indexPath: IndexPath, tableView: UITableView){
        if let attachments = news.attachments {
            imageSize = (attachments.width, attachments.height)
            imageViewFrame()
            
            let getCacheImage = GetCacheImage(url: attachments.url)
            getCacheImage.completionBlock = {
                OperationQueue.main.addOperation {
                    self.imagePhoto.image = getCacheImage.outputImage
                }
            }
            
            let setImageToRow = SetImageToRow(cell: cell, indexPath: indexPath, tableView: tableView)
            setImageToRow.addDependency(getCacheImage)
            queue.addOperation(getCacheImage)
            OperationQueue.main.addOperation(setImageToRow)
            
        } else {
            imageSize = (0, 0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatar ()
        author ()
        imageViewFrame()
        statisticsViewFrame()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}
