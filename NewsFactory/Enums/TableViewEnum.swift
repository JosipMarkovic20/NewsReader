//
//  TableViewEnum.swift
//  NewsFactory
//
//  Created by Josip Marković on 31/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation


enum FavoritesTableViewSubjectEnum{
    case rowRemove([IndexPath])
    case rowInsert([IndexPath])
}

enum NewsFeedTableViewSubjectEnum{
    case reloadRows([IndexPath])
    case reloadTable
}
