//
//  SetImageToRow.swift
//  VKclient
//
//  Created by Никита Латышев on 25.08.2018.
//  Copyright © 2018 Никита Латышев. All rights reserved.
//

import Foundation
import UIKit

class SetImageToRow: Operation {
    private let indexPath: IndexPath
    private weak var tableView: UITableView?
    private var cell: NewsCell?
    
    init(cell: NewsCell, indexPath: IndexPath, tableView: UITableView) {
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
            cell.imageNews.image = image
        } else if tableView.indexPath(for: cell) == nil {
            cell.imageNews.image = image
        }
    }
}
