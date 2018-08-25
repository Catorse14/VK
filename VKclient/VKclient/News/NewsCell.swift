//
//  NewsCell.swift
//  VKclient
//
//  Created by Никита Латышев on 24.08.2018.
//  Copyright © 2018 Никита Латышев. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var statisticsBlock: UIView!{
        didSet {
            statisticsBlock.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var authorNews: UILabel!{
        didSet {
            authorNews.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var textNews: UILabel!{
        didSet {
            textNews.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var like: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var repost: UILabel!
    @IBOutlet weak var view: UILabel!
    
    let instets: CGFloat = 10.0
    var imageSize: (width: Int, height: Int) = (0, 0)
    let iconSideLinght: CGFloat = 62
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    func setAuthor (text: String){
        authorNews.text = text
        author()
    }
    func setTextNews (text: String){
        textNews.text = text
        newsText()
    }
    
    func setStatistics(news: News) {
        // лайки
        like.text = news.like
        
        //комментарии
        comments.text = news.comments
        
        // репосты
        repost.text = news.repost
        
        //просмотры
        view.text = news.view
        
        statisticsViewFrame()
    }
    
    func getCellHeight() -> CGFloat {
        var height: CGFloat = 0.0
        height += avatarImage.frame.size.height + instets * 3
        height += textNews.frame.size.height + instets * 3
        if imageSize != (0, 0) {
        height += imageNews.frame.size.height + 3 * instets}
        height += statisticsBlock.frame.size.height + 3 * instets
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
        avatarImage.frame = CGRect(origin: iconOrigin, size: iconSize)
        
        // закругленные углы
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        avatarImage.clipsToBounds = true
    }
    
    
    // Установка размеров и позиции автора новости
    func author () {
        let author = getLabelSize(text: authorNews.text!, font: authorNews.font)
        let authorX = bounds.width * 0.05 + 62 + bounds.width * 0.05
        let authorY = instets * 3 - 7
        let textOrigin = CGPoint(x: authorX, y: authorY)
        authorNews.frame = CGRect(origin: textOrigin, size: author)
    }
    
    // Установка размеров и позиции текста новости
    func newsText() {
        // получаем размер текста
        let text = getLabelSize(text: textNews.text!, font: textNews.font)
        // рассчитываем координату по оси Y
        let textY = iconSideLinght + instets * 5
        // получаем координаты верхней левой точки
        let textOrigin = CGPoint(x: instets, y: textY)
        // получаем фрейм и установливаем его UILabel
        textNews.frame = CGRect(origin: textOrigin, size: text)
    }
    
    // Установка размеров и позиции изображения
    func imageViewFrame() {
        guard imageSize.width != 0, imageSize.height != 0 else {
            imageNews.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
            return
        }
        let ratio = Double(imageSize.height) / Double(imageSize.width)
        let y = avatarImage.frame.size.height + textNews.frame.size.height + instets * 5
        let width = Double(bounds.width - instets * 2)
        let height = width * ratio
        let size = CGSize(width: width, height: ceil(height))
        let origin = CGPoint(x: instets, y: y)
        imageNews.frame = CGRect(origin: origin, size: size)
    }
    
    // Блок со статистикой
    func statisticsViewFrame() {
        let statisticsSize = CGSize(width: bounds.width, height: 60.0)
        var statisticsY = avatarImage.frame.size.height + textNews.frame.size.height + instets * 2
        if imageNews.frame.size.height != 0.0 {
            statisticsY += imageNews.frame.size.height + instets
        }
        let statisticsOrigin = CGPoint(x: 0.0, y: statisticsY)
        statisticsBlock.frame = CGRect(origin: statisticsOrigin, size: statisticsSize)
    }

    func attachments (news: News, cell: NewsCell, indexPath: IndexPath, tableView: UITableView){
        if let attachments = news.attachments {
            imageSize = (attachments.width, attachments.height)
            imageViewFrame()
            
            let getCacheImage = GetCacheImage(url: attachments.url)
            getCacheImage.completionBlock = {
                OperationQueue.main.addOperation {
                    self.imageNews.image = getCacheImage.outputImage
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
        newsText()
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
