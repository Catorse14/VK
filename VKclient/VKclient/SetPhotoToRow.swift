//
//  SetPhotoToRow.swift
//  VKclient
//
//  Created by Никита Латышев on 03.09.2018.
//  Copyright © 2018 Никита Латышев. All rights reserved.
//

import Foundation
import UIKit

class SetPhotoToRow: Operation {
    private let indexPath: IndexPath
    private weak var tableView: UICollectionView?
    private var cell: FriendsPhotoCell?
    
    init(cell: FriendsPhotoCell, indexPath: IndexPath, tableView: UICollectionView) {
        self.indexPath = indexPath
        self.tableView = tableView
        self.cell = cell
    }
    
    override func main() {
        guard let tableView = tableView,
            let cell = cell,
            let getCacheImage = dependencies[0] as? GetCacheImage,
            let image = getCacheImage.outputImage else { return }
        
        if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
            cell.photoFriend.image = image
        } else if tableView.indexPath(for: cell) == nil {
            cell.photoFriend.image = image
        }
    }
}
