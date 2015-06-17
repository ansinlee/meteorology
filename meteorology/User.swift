//
//  User.swift
//  meteorology
//
//  Created by LeeAnsin on 15/6/6.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import Foundation
import UIKit

class User {
    var Id: Int32?
    var Icon: String?
    var Nick: String?

    
    init(id: Int32?, icon: String?, nick: String?) {
        self.Id = id
        self.Icon = icon
        self.Nick = nick
    }
    
    init(u: User) {
        self.Id = u.Id
        self.Icon = u.Icon
        self.Nick = u.Nick
    }
    
    init(data:AnyObject?) {
        if data == nil {
            return
        }
        self.Id = (data?.objectForKey("Id") as! NSNumber).intValue
        self.Icon = data?.objectForKey("Icon") as? String
        self.Nick = data?.objectForKey("Nick") as? String
    }
}