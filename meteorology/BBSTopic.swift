//
//  BBSTopic.swift
//  meteorology
//
//  Created by LeeAnsin on 15/3/29.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import Foundation
import UIKit

class Topic {
    var Id: Int32?
    var Img: String?
    var Title: String?
    var Abstract:String?
    var Time: String?
    var Creator: User?
    var Content:TopicDetailContent?
    
    init(id: Int32?, img: String?, title: String?, abstract: String?, time:String?, creator:User?, content: TopicDetailContent?) {
        self.Id = id
        self.Img = img
        self.Title = title
        self.Abstract = abstract
        self.Time = time
        self.Creator = creator
        self.Content = content
    }
    
    init(t: Topic) {
        self.Id = t.Id
        self.Img = t.Img
        self.Title = t.Title
        self.Abstract = t.Abstract
        self.Time = t.Time
        self.Creator = t.Creator
        self.Content = t.Content
    }
    
    init(data:AnyObject?) {
        if data == nil {
            return
        }
        self.Id = (data?.objectForKey("Id") as! NSNumber).intValue
        self.Img = data?.objectForKey("Img") as? String
        self.Time = GetGoDate(data?.objectForKey("Createtime") as! String)
        self.Title = data?.objectForKey("Title") as? String
        self.Abstract = data?.objectForKey("Abstract")as? String
        self.Content = TopicDetailContent(data: data?.objectForKey("Content"))
    }
}

enum TopicDetailItemType: Int {
    case Text = 0
    case Image = 1
}

class TopicDetailItem {
    var Type: TopicDetailItemType?
    var Data: String?
    
    init(type: TopicDetailItemType?, data: String?){
        self.Type = type
        self.Data = data
    }
}

class TopicDetailContent {
    var ItemList: [TopicDetailItem]?
    init(itemList: [TopicDetailItem]?) {
        self.ItemList = itemList
    }
    
    init(data:AnyObject?) {
        if data == nil {
            return
        }
        self.ItemList  = []
        var list:[AnyObject] = data as! [AnyObject]
        for i in 0...list.count-1 {
            if list[i].objectForKey("type") as! NSNumber == 0 {
                self.ItemList?.append(TopicDetailItem(type: TopicDetailItemType.Text, data: list[i].objectForKey("data")as? String))
            } else if list[i].objectForKey("type") as! NSNumber == 1 {
                self.ItemList?.append(TopicDetailItem(type: TopicDetailItemType.Image, data: list[i].objectForKey("data")as? String))
            }
        }
    }
}