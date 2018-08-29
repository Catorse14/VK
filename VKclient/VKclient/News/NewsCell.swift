//
//  NewsCell.swift
//  VKclient
//
//  Created by Никита Латышев on 24.08.2018.
//  Copyright © 2018 Никита Латышев. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var iconRepost: UIImageView!
    @IBOutlet weak var iconComment: UIImageView!
    @IBOutlet weak var iconLike: UIImageView!
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
    @IBOutlet weak var like: UILabel!{
        didSet {
            like.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var comments: UILabel!{
        didSet {
            comments.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var repost: UILabel!{
        didSet {
            repost.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var view: UILabel!{
        didSet {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    let instets: CGFloat = 10.0
    var imageSize: (width: Int, height: Int) = (0, 0)
    let iconSideLinght: CGFloat = 62
    let statisticIcon: CGFloat = 25
    //    var newsTextString: News
    
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
    func setLike (text: String){
        like.text = text
        likeCount()
    }
    func setComment (text: String){
        comments.text = text
        commentCount()
    }
    func setRepost (text: String){
        repost.text = text
        repostCount()
    }
    func setView (text: String){
        view.text = text
        viewCount()
    }
    
    
    func getCellHeight() -> CGFloat {
        var height: CGFloat = 0.0
        height = 3 * instets + iconSideLinght + 3 * instets + 3 * instets + textNews.frame.size.height + like.frame.size.height + 6 * instets
        
        // Проверяем, есть ли изображение в посте
        if imageSize != (0, 0){
            height += imageNews.frame.size.height + 3 * instets
        }
        
        // Проверяем, есть ли в посте текст
        if textNews.text!.isEmpty {
            height -= 2 * instets
        }
        return height
    }
    
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        var size:CGSize
        
        // Если строка с текстом поста пустая, то ширине и высоте блока текста присваиваем 0
        if text.isEmpty {
            size = CGSize(width: 0, height: 0)
        } else {
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
            size = CGSize(width: ceil(width), height: ceil(height))
        }
        return size
    }
    
    func avatar () {
        let iconSize = CGSize(width: iconSideLinght, height: iconSideLinght)
        let iconOrigin = CGPoint(x: bounds.midX * 0.05, y: 3 * instets)
        avatarImage.frame = CGRect(origin: iconOrigin, size: iconSize)
        
        // закругленные углы
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        avatarImage.clipsToBounds = true
    }
    
    
    // Установка размеров и позиции автора новости
    func author () {
        let author = getLabelSize(text: authorNews.text!, font: authorNews.font)
        let authorX = bounds.width * 0.05 + 62 + bounds.width * 0.05
        let authorY = instets * 5
        let textOrigin = CGPoint(x: authorX, y: authorY)
        authorNews.frame = CGRect(origin: textOrigin, size: author)
    }
    
    // Установка размеров и позиции текста новости
    func newsText() {
        // получаем размер текста
        let text = getLabelSize(text: textNews.text!, font: textNews.font)
        // рассчитываем координату по оси Y
        let textY = 3 * instets + iconSideLinght + 3 * instets
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
        var y:CGFloat = 0
        
        // Если приходит пустой строка текста новсти в Label, то убираем лишние отступы
        if textNews.text!.isEmpty {
            y = 3 * instets + iconSideLinght + 3 * instets
        } else {
            
            // Иначе добавляем отступы
            y = 3 * instets + iconSideLinght + 3 * instets + textNews.frame.size.height + 3 * instets
        }
        let width = Double(bounds.width - instets * 2)
        let height = width * ratio
        let size = CGSize(width: width, height: ceil(height))
        let origin = CGPoint(x: instets, y: y)
        imageNews.frame = CGRect(origin: origin, size: size)
    }
    
    // Установка размеров и позиции изображения Like
    func likeIcon () {
        let iconSize = CGSize(width: statisticIcon, height: statisticIcon)
        var iconOrigin:CGPoint
        
        // Если приходит пустой строка текста новсти в Label, то убираем лишние отступы
        if textNews.text!.isEmpty {
            iconOrigin = CGPoint(x: bounds.width * 0.05, y: 3 * instets + iconSideLinght + 3 * instets + imageNews.frame.size.height + 3 * instets)
        } else {
            
            // Иначе добавляем отступы
            iconOrigin = CGPoint(x: bounds.width * 0.05, y: 3 * instets + iconSideLinght + 3 * instets + textNews.frame.size.height + 3 * instets + imageNews.frame.size.height + 3 * instets)
        }
        iconLike.frame = CGRect(origin: iconOrigin, size: iconSize)
    }
    
    // Установка размеров и позиции количества Like
    func likeCount() {
        // получаем размер текста
        let text = getLabelSize(text: like.text!, font: like.font)
        // рассчитываем координату по оси X
        let textX = bounds.width * 0.05 + 3 * instets
        var textY:CGFloat
        
        // Если приходит пустой строка текста новсти в Label, то убираем лишние отступы
        if textNews.text!.isEmpty {
            textY = 9 * instets + iconSideLinght + imageNews.frame.size.height
        } else {
            
            // Иначе добавляем отступы
            textY = 12 * instets + iconSideLinght + textNews.frame.size.height + imageNews.frame.size.height
        }
        // получаем координаты верхней левой точки
        let textOrigin = CGPoint(x: textX, y: textY)
        // получаем фрейм и установливаем его UILabel
        like.frame = CGRect(origin: textOrigin, size: text)
    }
    
    // Установка размеров и позиции изображения Comment
    func commentIcon () {
        let iconSize = CGSize(width: statisticIcon, height: statisticIcon)
        var iconOrigin:CGPoint
        
        // Если приходит пустой строка текста новсти в Label, то убираем лишние отступы
        if textNews.text!.isEmpty {
            iconOrigin = CGPoint(x: bounds.width * 0.05 + 3 * instets + like.frame.size.width + bounds.width * 0.07, y: 3 * instets + iconSideLinght + 3 * instets + imageNews.frame.size.height + 3 * instets)
        } else {
            
            // Иначе добавляем отступы
            iconOrigin = CGPoint(x: bounds.width * 0.05 + 3 * instets + like.frame.size.width + bounds.width * 0.07, y: 3 * instets + iconSideLinght + 3 * instets + textNews.frame.size.height + 3 * instets + imageNews.frame.size.height + 3 * instets)
        }
        iconComment.frame = CGRect(origin: iconOrigin, size: iconSize)
    }
    
    // Установка размеров и позиции количества Comment
    func commentCount() {
        // получаем размер текста
        let text = getLabelSize(text: comments.text!, font: comments.font)
        // рассчитываем координату по оси X
        let textX = bounds.width * 0.05 + 3 * instets + like.frame.size.width + bounds.width * 0.07 + 3 * instets
        var textY:CGFloat
        
        // Если приходит пустой строка текста новсти в Label, то убираем лишние отступы
        if textNews.text!.isEmpty {
            textY = 9 * instets + iconSideLinght + imageNews.frame.size.height
        } else {
            
            // Иначе добавляем отступы
            textY = 12 * instets + iconSideLinght + textNews.frame.size.height + imageNews.frame.size.height
        }
        // получаем координаты верхней левой точки
        let textOrigin = CGPoint(x: textX, y: textY)
        // получаем фрейм и установливаем его UILabel
        comments.frame = CGRect(origin: textOrigin, size: text)
    }
    
    // Установка размеров и позиции изображения Repost
    func repostIcon() {
        let iconSize = CGSize(width: statisticIcon, height: statisticIcon)
        var iconOrigin:CGPoint
        
        // Если приходит пустой строка текста новсти в Label, то убираем лишние отступы
        if textNews.text!.isEmpty {
            iconOrigin = CGPoint(x: bounds.width * 0.05 + 3 * instets + like.frame.size.width + bounds.width * 0.07 + 3 * instets + bounds.width * 0.07, y: 3 * instets + iconSideLinght + 3 * instets + imageNews.frame.size.height + 3 * instets)
        } else {
            
            // Иначе добавляем отступы
            iconOrigin = CGPoint(x: bounds.width * 0.05 + 3 * instets + like.frame.size.width + bounds.width * 0.07 + 3 * instets + bounds.width * 0.07, y: 3 * instets + iconSideLinght + 3 * instets + textNews.frame.size.height + 3 * instets + imageNews.frame.size.height + 3 * instets)
        }
        iconRepost.frame = CGRect(origin: iconOrigin, size: iconSize)
    }
    
    // Установка размеров и позиции количества Repost
    func repostCount() {
        // получаем размер текста
        let text = getLabelSize(text: repost.text!, font: repost.font)
        // рассчитываем координату по оси X
        let textX = bounds.width * 0.05 + 3 * instets + like.frame.size.width + bounds.width * 0.07 + 3 * instets + comments.frame.size.width + bounds.width * 0.07 + 3 * instets
        var textY:CGFloat
        
        // Если приходит пустой строка текста новсти в Label, то убираем лишние отступы
        if textNews.text!.isEmpty {
            textY = 9 * instets + iconSideLinght + imageNews.frame.size.height
        } else {
            
            // Иначе добавляем отступы
            textY = 12 * instets + iconSideLinght + textNews.frame.size.height + imageNews.frame.size.height
        }
        // получаем координаты верхней левой точки
        let textOrigin = CGPoint(x: textX, y: textY)
        // получаем фрейм и установливаем его UILabel
        repost.frame = CGRect(origin: textOrigin, size: text)
    }
    
    // Установка размеров и позиции изображения View
    func viewIcon() {
        let iconSize = CGSize(width: statisticIcon, height: statisticIcon)
        var iconOrigin:CGPoint
        
        // Если приходит пустой строка текста новсти в Label, то убираем лишние отступы
        if textNews.text!.isEmpty {
            iconOrigin = CGPoint(x: bounds.width * 0.05 + 3 * instets + like.frame.size.width + bounds.width * 0.07 + 3 * instets + comments.frame.size.width + bounds.width * 0.07 + 3 * instets + repost.frame.size.width + bounds.width * 0.07, y: 3 * instets + iconSideLinght + 3 * instets + imageNews.frame.size.height + 3 * instets)
        } else {
            
            // Иначе добавляем отступы
            iconOrigin = CGPoint(x: bounds.width * 0.05 + 3 * instets + like.frame.size.width + bounds.width * 0.07 + 3 * instets + comments.frame.size.width + bounds.width * 0.07 + 3 * instets + repost.frame.size.width + bounds.width * 0.07, y: 3 * instets + iconSideLinght + 3 * instets + textNews.frame.size.height + 3 * instets + imageNews.frame.size.height + 3 * instets)
        }
        iconView.frame = CGRect(origin: iconOrigin, size: iconSize)
    }
    
    // Установка размеров и позиции количества View
    func viewCount() {
        // получаем размер текста
        let text = getLabelSize(text: view.text!, font: view.font)
        // рассчитываем координату по оси X
        let textX = bounds.width * 0.05 + 3 * instets + like.frame.size.width + bounds.width * 0.07 + 3 * instets + comments.frame.size.width + bounds.width * 0.07 + 3 * instets + repost.frame.size.width + bounds.width * 0.07 + 3 * instets
        var textY:CGFloat
        
        // Если приходит пустой строка текста новсти в Label, то убираем лишние отступы
        if textNews.text!.isEmpty {
            textY = 9 * instets + iconSideLinght + imageNews.frame.size.height
        } else {
            
            // Иначе добавляем отступы
            textY = 12 * instets + iconSideLinght + textNews.frame.size.height + imageNews.frame.size.height
        }
        // получаем координаты верхней левой точки
        let textOrigin = CGPoint(x: textX, y: textY)
        // получаем фрейм и установливаем его UILabel
        view.frame = CGRect(origin: textOrigin, size: text)
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
        likeIcon ()
        likeCount()
        commentIcon()
        commentCount()
        repostIcon()
        repostCount()
        viewIcon()
        viewCount()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
