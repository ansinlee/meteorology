//
//  PediaListView.swift
//  meteorology
//
//  Created by LeeAnsin on 15/3/22.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit

class PediaListProvider {
    
    static let pageSize = 10
    
    static let Classes = ["精选","风","雨","雷","电","云","雾","雪","霜","霾","其他"]
    
    class func loadPediaData(index: Int, completion:([Subject] -> Void)) {
        var dataList:[Subject] = []
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            var url = NSURL(string:GetUrl("/subject?offset=\(0)&limit=\(self.pageSize)&query=classid:\(index)"))
            if index == 1 {
                url = NSURL(string:GetUrl("/subject?offset=\(0)&limit=\(self.pageSize)&query=isrcmmd:1"))
            }
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
                    var list = retdata!
                    var len = list.count-1
                    for i in 0...len {
                        var subject = Subject(data: list[i])
                        dataList.append(subject)
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                completion(dataList)
            }
        }
    }
    
    class func searchData(query: String, completion:([Subject] -> Void)) {
        var dataList:[Subject] = []
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            var url = NSURL(string:GetUrl("/subject?offset=\(0)&limit=\(self.pageSize)&query=title.contains:\(query)"))
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
                    var list = retdata!
                    var len = list.count-1
                    for i in 0...len {
                        var subject = Subject(data: list[i])
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
