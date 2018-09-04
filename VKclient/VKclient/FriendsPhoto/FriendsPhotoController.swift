//
//  FriendsPhotoController.swift
//  VKclient
//
//  Created by Никита Латышев on 24.08.2018.
//  Copyright © 2018 Никита Латышев. All rights reserved.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "Cell"

class FriendsPhotoController: UICollectionViewController {
    var friend: Friends?
    var photoList: [Photo] = []
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Задаем цвет кнопки назад
        self.navigationController?.navigationBar.tintColor = UIColor.white
        loadData()
        
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    // Получаем фотографии друга
    func loadData() {
        let service = Service()
        let userID = friend!.id
        service.getFriendPhotos(ownerId: userID) { (photos, error) in
            // TODO: обработка ошибок
            if let error = error {
                print(error)
                return
            }
            // получили фото друга
            if let photo = photos {
                self.photoList = photo
                // обновить collectionView
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendsPhoto", for: indexPath) as! FriendsPhotoCell
        let photo = URL(string: photoList[indexPath.row].photo)
        cell.photoFriend.kf.setImage(with: photo)
        
        let getCacheImage = GetCacheImage(url: photoList[indexPath.row].photo)
        getCacheImage.completionBlock = {
            OperationQueue.main.addOperation {
                cell.photoFriend.image = getCacheImage.outputImage
            }
        }
        
        let setImageToRow = SetPhotoToRow(cell: cell, indexPath: indexPath, tableView: collectionView)
        setImageToRow.addDependency(getCacheImage)
        queue.addOperation(getCacheImage)
        OperationQueue.main.addOperation(setImageToRow)
        
        return cell
    }
}
