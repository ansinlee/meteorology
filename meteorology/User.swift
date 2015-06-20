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

var currentUser: User!

func GetCurrentUser() ->User {
    if (currentUser != nil) {
        return currentUser
    }
    let ud = NSUserDefaults.standardUserDefaults()
    var id = ud.integerForKey("User.Id")
    if id <= 0 {
        currentUser = User(id: 0, icon: "", nick: "游客")
    } else {
        let icon = ud.valueForKey("User.Icon") as! String
        let nick = ud.valueForKey("User.Nick") as! String
        currentUser = User(id: Int32(id), icon: icon, nick: nick)
    }

    NSLog("Init CurrentUser : \(currentUser.Id) \(currentUser.Nick) [\(currentUser.Icon)]")
    return currentUser
}

func CheckIsLogin()->Bool {
    return GetCurrentUser().Id != 0
}

func Login(u: User) {
    let ud = NSUserDefaults.standardUserDefaults()
    ud.setInteger(Int(u.Id!), forKey: "User.Id")
    ud.setValue(u.Icon, forKey: "User.Icon")
    ud.setValue(u.Nick, forKey: "User.Nick")
    currentUser = u
}

func Logout() {
    let ud = NSUserDefaults.standardUserDefaults()
    ud.setInteger(0, forKey: "User.Id")
    currentUser = nil
}