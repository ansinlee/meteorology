//
//  BBSReply.swift
//  meteorology
//
//  Created by LeeAnsin on 15/6/14.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import Foundation

class Reply {
    var Id: Int32?
    var TopicId: Int32?
    var Time: String?
    var Creator: User?
    var Content:String?
    
    init(id: Int32?, topicid: Int32?, time:String?, creator:User?, content: String?) {
        self.Id = id
        self.TopicId = topicid
        self.Time = time
        self.Creator = creator
        self.Content = content
    }
    
    init(t: Reply) {
        self.Id = t.Id
        self.TopicId = t.TopicId
        self.Time = t.Time
        self.Creator = t.Creator
        self.Content = t.Content
    }
    
    init(data:AnyObject?) {
        if data == nil {
            return
        }
        self.Id = (data?.objectForKey("Id") as! NSNumber).intValue
        self.TopicId = (data?.objectForKey("Topicid") as! NSNumber).intValue
        self.Time = GetGoDate(data?.objectForKey("Createtime") as! String)
        self.Content = data?.objectForKey("Content") as? String
        self.Creator = User(data: data?.objectForKey("Creator"))
    }
}
