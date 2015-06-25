//
//  ProfTopicViewController.swift
//  meteorology
//
//  Created by sunsing on 6/19/15.
//  Copyright (c) 2015 LeeAnsin. All rights reserved.
//

import UIKit

class ProfSubjectViewController: UITableViewController {
    var currentDataSource:[Subject] = []
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func loadListData(readmore:Bool) {
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            self.isLoading = true
            if !readmore {
                self.currentDataSource = []
                self.currentPage = 0
            }
            var url = NSURL(string:GetUrl("/subject?offset=\(PediaListProvider.pageSize*self.currentPage)&limit=\(PediaListProvider.pageSize)&query=creatorid:\(GetCurrentUser().Id!)"))
            
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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.currentDataSource.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("subjectcell", forIndexPath: indexPath) as! UITableViewCell
        if currentDataSource.count <= indexPath.row {
            return cell
        }
        let subject = currentDataSource[indexPath.row]
        if (subject.Img == nil) {
            (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "default")
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0)) {
                var data = NSData(contentsOfURL: NSURL(string: subject.Img!)!)
                dispatch_async(dispatch_get_main_queue()) {
                    if data != nil {
                        (cell.viewWithTag(1) as! UIImageView).image = UIImage(data: data!)
                    } else {
                        (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "default")
                    }
                }
            }
        }
        (cell.viewWithTag(2) as! UILabel).text = subject.Title
        (cell.viewWithTag(3) as! UILabel).text = subject.Abstract
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if indexPath.row < currentDataSource.count {
            let subject = currentDataSource[indexPath.row]
            let detailVC = PediaDetailViewController(subject: subject)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("layoutMargins") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
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
