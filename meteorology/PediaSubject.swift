//
//  PediaSubject.swift
//  meteorology
//
//  Created by LeeAnsin on 15/3/29.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import Foundation
import UIKit

class Subject {
    var Id: Int32?
    var Img: String? = ""
    var Title: String?
    var Abstract:String?
    var Content:SubjectDetailContent?
    
    init(id: Int32?, img: String?, title: String?, abstract: String?, content: SubjectDetailContent?) {
        self.Id = id
        self.Img = img
        self.Title = title
        self.Abstract = abstract
        self.Content = content
    }
    
    init(s: Subject) {
        self.Id = s.Id
        self.Img = s.Img
        self.Title = s.Title
        self.Abstract = s.Abstract
        self.Content = s.Content
    }
    
    init(data:AnyObject?) {
        if data == nil {
            return
        }
        self.Id = (data?.objectForKey("Id") as! NSNumber).intValue
        self.Img = data?.objectForKey("Img") as? String
        self.Title = data?.objectForKey("Title") as? String
        self.Abstract = data?.objectForKey("Abstract")as? String
        self.Content = SubjectDetailContent(data: data?.objectForKey("Content"))
    }
}

enum SubjectDetailItemType: Int {
    case Text = 0
    case Image = 1
}

class SubjectDetailItem {
    var Type: SubjectDetailItemType?
    var Data: String?
    
    init(type: SubjectDetailItemType?, data: String?){
        self.Type = type
        self.Data = data
    }
}

class SubjectDetailContent {
    var ItemList: [SubjectDetailItem]?
    init(itemList: [SubjectDetailItem]?) {
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
                self.ItemList?.append(SubjectDetailItem(type: SubjectDetailItemType.Text, data: list[i].objectForKey("data")as? String))
            } else if list[i].objectForKey("type") as! NSNumber == 1 {
                self.ItemList?.append(SubjectDetailItem(type: SubjectDetailItemType.Image, data: list[i].objectForKey("data")as? String))
            }
        }
    }
}
