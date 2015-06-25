//
//  ProfBBSViewController.swift
//  meteorology
//
//  Created by sunsing on 6/19/15.
//  Copyright (c) 2015 LeeAnsin. All rights reserved.
//

import UIKit

class ProfTopicViewController: UITableViewController {
    var currentDataSource:[Topic] = []
    var currentPage = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadListData(false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if tableView.respondsToSelector("layoutMargins") {
            self.tableView.layoutMargins = UIEdgeInsetsZero
        }
        self.tableView.separatorInset = UIEdgeInsetsZero
    }
    // MARK: load data
    func loadListData(readmore:Bool) {
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            self.isLoading = true
            if !readmore {
                self.currentDataSource = []
                self.currentPage = 0
            }
            var url = NSURL(string:GetUrl("/topic?offset=\(PediaListProvider.pageSize*self.currentPage)&limit=\(PediaListProvider.pageSize)&query=creatorid:\(GetCurrentUser().Id!)"))
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
                        var subject = Topic(data: list[i])
                        self.currentDataSource.append(subject)
                    }
                    self.currentPage++
                }
            }
    
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                self.isLoading = false
            }
        }
    }
    
    // MARK: scrollview delagate
    var isLoading = false
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        //println("77777777 \(scrollView.contentSize.height - scrollView.frame.size.height): \(currentPage*10) \(self.currentDataSource.count) \(isLoading)")
        if scrollView == tableView && scrollView.contentSize.height - scrollView.frame.size.height > 0 && currentPage*PediaListProvider.pageSize == self.currentDataSource.count && !isLoading {
            if scrollView.contentOffset.y >  scrollView.contentSize.height - scrollView.frame.size.height + 44 {
                self.loadListData(true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.currentDataSource.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("topiccell", forIndexPath: indexPath) as! UITableViewCell
        let topic = currentDataSource[indexPath.row]
        if topic.Creator == nil || topic.Creator!.Icon == nil {
            (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "default_icon")
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0)) {
                var data = NSData(contentsOfURL: NSURL(string: topic.Creator!.Icon!)!)
                dispatch_async(dispatch_get_main_queue()) {
                    if data != nil {
                        (cell.viewWithTag(1) as! UIImageView).image = UIImage(data: data!)
                    } else {
                        (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "default_icon")
                    }
                }
            }
        }
        (cell.viewWithTag(2) as! UILabel).text = topic.Creator?.Nick ?? "匿名用户"
        (cell.viewWithTag(3) as! UILabel).text = topic.Time
        (cell.viewWithTag(4) as! UILabel).text = topic.Title
        (cell.viewWithTag(5) as! UILabel).text = topic.Abstract
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is BBSNewDetailViewController {
            if let desVC = segue.destinationViewController as? BBSNewDetailViewController {
                if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                    desVC.topic = currentDataSource[indexPath.row]
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("layoutMargins") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
}
