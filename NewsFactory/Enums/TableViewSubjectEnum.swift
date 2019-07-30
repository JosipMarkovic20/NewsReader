//
//  TableViewSubjectEnum.swift
//  NewsFactory
//
//  Created by Josip Marković on 30/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation

enum TableViewSubjectEnum{
    
    case tableViewReload
    case tableViewRowReload([IndexPath])
    
}

enum FavoritesTableViewSubjectEnum{
    
    case rowRemove([IndexPath])
    case rowInsert([IndexPath])
    
}

