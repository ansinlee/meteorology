//
//  PediaListView.swift
//  meteorology
//
//  Created by LeeAnsin on 15/3/22.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit

class BBSListProvider {
    
    static let pageSize = 10
    
    static var Classes = ["精选","风","雨雪","雷电","云","雾霜霾","其他"]
    static var ClassIds = [1,2,3,4,5,6,7]
    
    class func loadClasses() {
            var url = NSURL(string:GetUrl("/class?sortby=pos&order=asc&query=type:1"))
            //获取JSON数据
            var data = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingUncached, error: nil)
            if data != nil {
                var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data!,options:NSJSONReadingOptions.AllowFragments,error:nil)!
                
                //解析获取JSON字段值
                var errcode:NSNumber = json.objectForKey("errcode") as! NSNumber //json结构字段名。
                var errmsg:String? = json.objectForKey("errmsg") as? String
                var retdata:NSArray? = json.objectForKey("data") as? NSArray
                NSLog("errcode:\(errcode) errmsg:\(errmsg) data:\(retdata)")
                
                if errcode == 0 && retdata != nil {
                    var classList:[String] = []
                    var classidList:[Int] = []
                    var list = retdata!
                    var len = list.count-1
                    for i in 0...len {
                        let cls: AnyObject = list[i]
                        classList.append(cls.objectForKey("Name") as! String)
                        classidList.append((cls.objectForKey("Id") as! NSNumber).integerValue)
                    }
                    self.Classes = classList
                    self.ClassIds = classidList
                }
            }
    }
    
    // MARK: load data
    
    class func loadTopicData(index: Int, page:Int, completion:([Topic] -> Void)) {
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            var url = NSURL(string:GetUrl("/topic?offset=\(page*self.pageSize)&limit=\(self.pageSize)&query=classid:\(index)&sortby=id&order=desc"))
            //获取JSON数据
            var dataList:[Topic] = []
            var data = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingUncached, error: nil)
            if data != nil {
                var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data!,options:NSJSONReadingOptions.AllowFragments,error:nil)!
                
                //解析获取JSON字段值
                var errcode:NSNumber = json.objectForKey("errcode") as! NSNumber //json结构字段名。
                var errmsg:String? = json.objectForKey("errmsg") as? String
                var retdata:NSArray? = json.objectForKey("data") as? NSArray
                NSLog("errcode:\(errcode) errmsg:\(errmsg) data:\(retdata)")
                
                if errcode == 0 && retdata != nil {
                    var list = retdata!
                    var len = list.count-1
                    for i in 0...len {
                        var subject = Topic(data: list[i])
                        dataList.append(subject)
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                completion(dataList)
            }
        }
    }
}
