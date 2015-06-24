//
//  BBSNewDetailViewController.swift
//  meteorology
//
//  Created by sunsing on 6/19/15.
//  Copyright (c) 2015 LeeAnsin. All rights reserved.
//

import UIKit

class BBSNewDetailViewController: UIViewController {
    
    var topic: Topic!
    
    var replyListData:[Reply] = []
    var replyCurrentPage = 0
    
    // MARK: scrollview delagate
    var isLoading = false
    
    @IBOutlet weak var containerViewBottomConstraint:NSLayoutConstraint!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDetailContent()
        self.loadReplyListData(false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.ka_startObservingKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.ka_stopObservingKeyboardNotifications()
        //self.view.layoutIfNeeded()
    }
    
    override func ka_keyboardShowOrHideAnimationWithHeight(height: CGFloat, animationDuration: NSTimeInterval, animationCurve: UIViewAnimationCurve) {
        self.containerViewBottomConstraint.constant = height
        //self.view.layoutIfNeeded()
    }

    // 计算文本框高度
    func caculateLableHeight(text: String?, fontSize: CGFloat, showWidth: CGFloat) -> CGFloat {
        if text == nil {
            return 0
        }
        var sizeToFit:CGSize = NSString(string: text!).boundingRectWithSize(
            CGSizeMake(showWidth, CGFloat(MAXFLOAT)),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName:UIFont.systemFontOfSize(fontSize)],
            context: nil).size
        return sizeToFit.height
    }
    

    func loadDetailContent() {
        NSLog("详情 : \(self.topic?.Title)")
        //定义获取json数据的接口地址，这里定义的是获取天气的API接口,还有一个好处，就是swift语句可以不用强制在每条语句结束的时候用";"
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            var id:Int32 = self.topic!.Id!
            var url = NSURL(string:GetUrl("/topic/\(id)"))
            //获取JSON数据
            var data = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingUncached, error: nil)
            var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data!,options:NSJSONReadingOptions.AllowFragments,error:nil)!
            
            //解析获取JSON字段值
            var errcode:NSNumber = json.objectForKey("errcode") as! NSNumber //json结构字段名。
            var errmsg:String? = json.objectForKey("errmsg") as? String
            var retdata:NSDictionary? = json.objectForKey("data") as? NSDictionary
            NSLog("errcode:\(errcode) errmsg:\(errmsg) data:\(retdata)")
            
            if errcode == 0 {
                self.topic?.Content = TopicDetailContent(data: retdata?.objectForKey("Content"))
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }

    func loadReplyListData(readmore: Bool) {
        if (!readmore) {
            self.replyCurrentPage = 0
            self.replyListData = []
        }
        
        var id:Int32 = self.topic.Id!
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            self.isLoading = true
            var url = NSURL(string:GetUrl("/reply?offset=\(self.replyCurrentPage*PediaListProvider.pageSize)&limit=\(PediaListProvider.pageSize)&query=topicid:\(id)&sortby=id&order=desc"))
            //获取JSON数据
            var data = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingUncached, error: nil)
            if data != nil {
                var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data!,options:NSJSONReadingOptions.AllowFragments,error:nil)!
                
                //解析获取JSON字段值
                var errcode:NSNumber = json.objectForKey("errcode") as! NSNumber //json结构字段名。
                var errmsg:String? = json.objectForKey("errmsg") as? String
                var retdata:NSArray? = json.objectForKey("data") as? NSArray
                
                
                if errcode == 0 && retdata != nil {
                    var list = retdata!
                    var len = list.count-1
                    for i in 0...len {
                        var reply = Reply(data: list[i])
                        self.replyListData.append(reply)
                        NSLog("add a reply \(reply)")
                    }
                    self.replyCurrentPage++
                }
                self.isLoading = false
                NSLog("errcode:\(errcode) errmsg:\(errmsg) data:\(retdata)")
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
            }
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BBSNewDetailViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return replyListData.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "帖子详情"
        }
        return "最新回复"
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            var height = caculateLableHeight(topic.Title, fontSize: 18, showWidth: self.view.frame.width - 16) + 8
            if topic.Content!.ItemList == nil {
                return height + 8
            }
            
            var tmpHeight:CGFloat = 0
            for item in topic.Content!.ItemList! {
                if item.Type! == .Text {
                    tmpHeight += caculateLableHeight(item.Data!, fontSize: 18, showWidth: self.view.frame.width - 16)
                } else {
                    tmpHeight += 208
                }
            }
            return height + tmpHeight + 16
        }
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCellWithIdentifier("bbscell", forIndexPath: indexPath) as? UITableViewCell {
                (cell.viewWithTag(1) as! UILabel).text = topic.Title
                if topic.Content!.ItemList != nil {
                    for item in topic.Content!.ItemList! {
                        if item.Type! == .Text {
                            (cell.viewWithTag(2) as! UILabel).text = item.Data
                        } else {
                            dispatch_async(dispatch_get_global_queue(0, 0)) {
                                var data = NSData(contentsOfURL: NSURL(string: item.Data!)!)
                                if data != nil {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        (cell.viewWithTag(3) as! UIImageView).image =  UIImage(data: data!)
                                    }
                                }
                            }
                        }
                    }

                }
                return cell
            }
            return UITableViewCell()
        }
        if let cell = tableView.dequeueReusableCellWithIdentifier("replycell", forIndexPath: indexPath) as? UITableViewCell {
            if replyListData.count <= indexPath.row {
                return UITableViewCell()
            }
            let replay = replyListData[indexPath.row]
            if replay.Creator == nil || replay.Creator!.Icon == nil {
                (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "default_icon")
            } else {
                dispatch_async(dispatch_get_global_queue(0, 0)) {
                    var data = NSData(contentsOfURL: NSURL(string: replay.Creator!.Icon!)!)
                    dispatch_async(dispatch_get_main_queue()) {
                        if data != nil {
                            (cell.viewWithTag(1) as! UIImageView).image = UIImage(data: data!)
                        } else {
                            (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "default_icon")
                        }
                    }
                }
            }
            (cell.viewWithTag(2) as! UILabel).text = replay.Creator?.Nick ?? "匿名用户"
            (cell.viewWithTag(3) as! UILabel).text = replay.Time
            (cell.viewWithTag(4) as! UILabel).text = replay.Content
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: scrollview delagate
    func scrollViewDidScroll1(scrollView: UIScrollView) {
        //println("77777777 \(scrollView.contentSize.height - scrollView.frame.size.height): \(replyCurrentPage*10) \(self.replyListData.count) \(isLoading)")
        if (self.tableView != nil && scrollView == self.tableView && scrollView.contentSize.height - scrollView.frame.size.height > 0 && (self.replyCurrentPage)*PediaListProvider.pageSize == self.replyListData.count && !isLoading) {
            //println("\(scrollView.contentOffset.y):\(scrollView.contentSize.height - scrollView.frame.size.height)")
            if scrollView.contentOffset.y >  scrollView.contentSize.height - scrollView.frame.size.height + 44 {
                self.loadReplyListData(true)
            }
        }
    }
}

extension BBSNewDetailViewController:UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let text = textField.text {
            textField.resignFirstResponder()
            // TODO: send request reload data
            NSLog("begint reply : \(text)")
            var post = "{\"Content\":\"\(text)\", \"Topicid\":\(self.topic!.Id!),  \"Pid\":0, \"Creatorid\":\(GetCurrentUser().Id!)}"
            
            dispatch_async(dispatch_get_global_queue(0, 0)) {
                var url = NSURL(string: GetUrl("/reply"))
                var request = NSMutableURLRequest(URL: url!)
                request.HTTPMethod = "POST"
                request.setValue("\(post.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))", forHTTPHeaderField: "Content-Length")
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField:"Content-Type")
                request.HTTPBody = post.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                let postTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data: NSData!, resp: NSURLResponse!, err:NSError!)-> Void in
                    NSLog("\(data) \(err) \(request.HTTPBody) \(resp)")
                    if err == nil {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.contentOffset = CGPointZero
                            textField.text = ""
                            //self.tableView.reloadData()
                            self.loadReplyListData(false)
                        }
                    }
                })
                postTask.resume()
            }
            return true
        }
        return true
    }
}
