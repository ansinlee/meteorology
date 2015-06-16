//
//  url.swift
//  meteorology
//
//  Created by LeeAnsin on 15/6/13.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import Foundation

let hostprod = "http://www.ansinlee.com:8080/v1"
let hostdebug = "http://127.0.0.1:8080/v1"
let debug = false

func GetUrl(path: String) -> String {
    var host:String
    if debug {
        host = hostdebug
    } else {
        host = hostprod
    }
    var url = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (host+path), "!$&'()*+,-./:;=?@_~%#[]", nil,  CFStringBuiltInEncodings.UTF8.rawValue)
    NSLog("url : \(host)\(path)")
    return "\(url)"
}

func GetGoDate(date: String) -> NSDate? {
    var GoDateFormatter = NSDateFormatter()
    GoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    var d = GoDateFormatter.dateFromString(date)
    if d == nil {
        d = NSDate()
    }
    return d
}


func GetPrintDateString(date:NSDate?)->String {
    var d = date
    if date == nil {
        d = NSDate(timeIntervalSince1970: 0)
    }
    var dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.stringFromDate(d!)
}

