//
//  ProfBBSViewController.swift
//  meteorology
//
//  Created by sunsing on 6/19/15.
//  Copyright (c) 2015 LeeAnsin. All rights reserved.
//

import UIKit

class ProfBBSViewController: UITableViewController {
    var currentDataSource:[Topic] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadListData()
    }
    
    // MARK: load data
    func loadListData() {
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            var url = NSURL(string:GetUrl("/topic?offset=\(0)&limit=\(10)&query=creatorid:\(GetCurrentUser().Id!)"))
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
            self.currentDataSource = dataList
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
            let subject = currentDataSource[indexPath.row]
        if subject.Creator == nil || subject.Creator!.Icon == nil {
            (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "default")
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0)) {
                var data = NSData(contentsOfURL: NSURL(string: subject.Creator!.Icon!)!)
                dispatch_async(dispatch_get_main_queue()) {
                    if data != nil {
                        (cell.viewWithTag(1) as! UIImageView).image = UIImage(data: data!)
                    } else {
                        (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "default")
                    }
                }
            }
        }
        (cell.viewWithTag(2) as! UILabel).text = subject.Creator?.Nick ?? "匿名用户"
        (cell.viewWithTag(3) as! UILabel).text = subject.Time
        (cell.viewWithTag(4) as! UILabel).text = subject.Title
        (cell.viewWithTag(5) as! UILabel).text = subject.Abstract
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(120)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
