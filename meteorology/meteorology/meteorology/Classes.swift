//
//  Classes.swift
//  meteorology
//
//  Created by LeeAnsin on 15/4/4.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import Foundation

class Class {
    var Id :Int32
    var Name: String

    init(id:Int32, name: String) {
        self.Id = id
        self.Name = name
    }
}

var classesList: [Class]?

func GetClassesList() -> [Class] {
    if classesList == nil {
        classesList = [
            Class(id:1, name:"精选"),
            Class(id:2, name:"风"),
            Class(id:3, name:"雨"),
            Class(id:4, name:"雷"),
            Class(id:5, name:"电"),
            Class(id:6, name:"云"),
            Class(id:7, name:"雾"),
            Class(id:8, name:"雪"),
            Class(id:9, name:"霜"),
            Class(id:10, name:"霾"),
            Class(id:11, name:"其他"),
        ]
    }
    return classesList!
}

