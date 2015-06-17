//
//  PediaListView.swift
//  meteorology
//
//  Created by LeeAnsin on 15/3/22.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit

class BBSReplyListView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var isSearch:Bool?
    var queryData:AnyObject?
    var parentVC:UIViewController?
    
    var classid = 1
    var offset = 0
    var pageSize = 10
    
    var dataList:[Reply] = []
    
    let reuseCellIdentifier = "BBSReplyListTableCell"
    let cellHeight:CGFloat = 90
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.layer.cornerRadius = MainCornerRadius
        self.layer.masksToBounds = true
        self.backgroundColor = MainBackgroudColor
        self.showsVerticalScrollIndicator = false
        
        self.delegate = self
        self.dataSource = self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.dataList.count-1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:BBSReplyListTableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseCellIdentifier, forIndexPath: indexPath) as? BBSReplyListTableViewCell
        if cell == nil {
            cell = BBSReplyListTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseCellIdentifier)
        }
        
        NSLog("table view width \(tableView.frame.width)")
        
        // Configure the cell...
        var topic = self.dataList[indexPath.row]
        //cell?.setData(topic)
        
        NSLog("topic \(topic)")
        
        return cell! as UITableViewCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("table selected")
        //var detailVC = BBSDetailViewController(topic: self.dataList[indexPath.row])
        //self.parentVC?.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return false
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
}
