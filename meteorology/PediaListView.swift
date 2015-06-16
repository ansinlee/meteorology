//
//  PediaListView.swift
//  meteorology
//
//  Created by LeeAnsin on 15/3/22.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit

class PediaListView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var queryData:AnyObject?
    var parentVC:UIViewController?
    
    let pageSize = 10
    var offset:NSNumber = 0
    var classid:NSNumber = 1
    
    var dataList:[Subject] = [
        /*
        Subject(id: 1, img: UIImage(named: "IMG_0274.JPG"), title: "气象局", abstract: "安徽省阜阳市气象局是安徽省气象局的一个下属单位，里面有员工200人。", content: SubjectDetailContent(itemList: [
            SubjectDetailItem(type: SubjectDetailItemType.Text, data: "安徽省阜阳市气象局是安徽省气象局的一个下属单位，里面有员工200人。"),
            SubjectDetailItem(type: SubjectDetailItemType.Image, data: "http://b.hiphotos.baidu.com/baike/c0%3Dbaike92%2C5%2C5%2C92%2C30/sign=2e5009e0a9ec8a1300175fb2966afaea/9c16fdfaaf51f3decdf3946b94eef01f3a29797f.jpg"),
            SubjectDetailItem(type: SubjectDetailItemType.Text, data: "安徽省阜阳市气象局是安徽省气象局的一个下属单位，里面有员工200人。"),
            SubjectDetailItem(type: SubjectDetailItemType.Image, data: "http://b.hiphotos.baidu.com/baike/c0%3Dbaike92%2C5%2C5%2C92%2C30/sign=2e5009e0a9ec8a1300175fb2966afaea/9c16fdfaaf51f3decdf3946b94eef01f3a29797f.jpg"),
            SubjectDetailItem(type: SubjectDetailItemType.Text, data: "IOS学习了一段时间了，对于这个文本内容多了需要计算高度的问题特别蛋疼，这个根本没法和Android相比啊，Android根本就不用自己费心计算宽度和高度，内部都帮你实现好了，好了，YY到此结束，遇到这么蛋疼的问题还得需要解决。")
            ]))
            */
    ]
    
    let reuseCellIdentifier = "PediaListTableCell"
    let cellHeight:CGFloat = 120
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.layer.cornerRadius = MainCornerRadius
        self.layer.masksToBounds = true
        //self.backgroundColor = MainBackgroudColor
        self.backgroundColor = UIColor.whiteColor()
        self.showsVerticalScrollIndicator = false
        
        self.delegate = self
        self.dataSource = self
        self.registerClass(PediaListTableViewCell.self, forCellReuseIdentifier: reuseCellIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadListData(index: Int) {
        classid = index
        dataList = []
        
        var url = NSURL(string:GetUrl("/subject?offset=\(0)&limit=\(pageSize)&query=classid:\(classid)"))
        if classid == 1 {
            url = NSURL(string:GetUrl("/subject?offset=\(0)&limit=\(pageSize)&query=isrcmmd:1"))
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
        
        NSLog("load List Data \(index)")
        self.reloadData()
    }
    
    func searchData(query: String) {
        dataList = []

        var url = NSURL(string:GetUrl("/subject?offset=\(0)&limit=\(pageSize)&query=title.contains:\(query)"))
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
        self.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.dataList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:PediaListTableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseCellIdentifier, forIndexPath: indexPath) as? PediaListTableViewCell
        if cell == nil {
            cell = PediaListTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseCellIdentifier)
        }
    
        NSLog("table view width \(tableView.frame.width)")
        
        // Configure the cell...
        var Subject = self.dataList[indexPath.row]
        cell?.setData(Subject.Id!, img: Subject.Img!, title: Subject.Title!, abstract: Subject.Abstract!)

        return cell! as UITableViewCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("table selected")
        var detailVC = PediaDetailViewController(subject: self.dataList[indexPath.row])
        self.parentVC?.navigationController?.pushViewController(detailVC, animated: true)
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

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
