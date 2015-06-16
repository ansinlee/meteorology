//
//  PediaDetailViewController.swift
//  meteorology
//
//  Created by LeeAnsin on 15/3/22.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit

class BBSDetailViewController: UIViewController {
    let border = CGFloat(20)
    let titleFontSize = CGFloat(20)
    let contentTextFontSize = CGFloat(14)
    let replyTimeFontSize = CGFloat(10)
    let replyTextFontSize = CGFloat(12)
    let contetnImageHeight = CGFloat(200)
    let textStartSpace = "       "
    let contextCornerRadius = CGFloat(8)
    let replyFormHeight = CGFloat(40)
    
    var mainView: UIScrollView?
    var replyView: UIView?
    var titleLable: UILabel?
    var contentView: [UIView] = []
    var topic: Topic?
    var currentHeight:CGFloat = 0.0
    
    var replyTextField: UITextField?
    var replyButton: UIButton?
    
    var replyListData:[Reply] = []
    var replyPageSize:Int32 = 50
    
    init(topic:Topic?) {
        super.init(nibName: nil, bundle: nil)
        self.topic = topic
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = NavBarBackgroudColor
        self.title = "详情"
        
        
        // 添加回复区域
        // 添加主景
        self.replyView = UIView(frame: CGRect(x: -1, y: self.view.frame.height - BottomNavBarHeight-self.replyFormHeight, width: self.view.frame.width+2, height: self.replyFormHeight))
        self.replyView?.backgroundColor = UIColor.whiteColor()
        self.addReplyForm()
        self.view.addSubview(self.replyView!)
        
        // 添加主景
        self.mainView = UIScrollView(frame: CGRect(x: -1, y: UIApplication.sharedApplication().statusBarFrame.height + self.navigationController!.navigationBar.frame.height, width: self.view.frame.width+2, height: self.view.frame.height - UIApplication.sharedApplication().statusBarFrame.height - self.navigationController!.navigationBar.frame.height - BottomNavBarHeight-self.replyFormHeight))
        // 加圆角
        self.mainView?.layer.cornerRadius = MainCornerRadius
        self.mainView?.layer.masksToBounds = true
        self.mainView?.backgroundColor = UIColor.whiteColor()
        // 去掉滑动条
        self.mainView?.showsVerticalScrollIndicator = false
        // 加蓝色边框
        self.mainView?.layer.borderWidth = MainBorderWidth
        self.mainView?.layer.borderColor = NavBarBackgroudColor.CGColor
        self.view.addSubview(self.mainView!)
        
        // 添加标题
        self.titleLable = UILabel(frame: CGRect(x: self.border, y: self.border, width: self.mainView!.frame.width - self.border*2, height: self.caculateLableHeight(self.textStartSpace + self.topic!.Title! , fontSize: CGFloat(self.titleFontSize), showWidth: self.mainView!.frame.width - self.border*4)))
        self.titleLable?.lineBreakMode = NSLineBreakMode.ByCharWrapping
        self.titleLable?.numberOfLines = 0
        self.titleLable?.font = self.titleLable!.font.fontWithSize(self.titleFontSize)
        self.titleLable?.textAlignment = NSTextAlignment.Center
        self.titleLable?.text = topic?.Title
        self.mainView?.addSubview(self.titleLable!)
        
        self.currentHeight = self.titleLable!.frame.origin.y + self.titleLable!.frame.height + self.border
        NSLog("*************** current height : \(currentHeight)")
        
        // 禁用自动布局
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 添加正文
        self.loadDetailContent()
        
        // 添加分割线
        self.addSplitLine()
        
        // 添加回帖
        self.loadReplyListData()
    }

    func addReplyForm() {
        NSLog("begin add reply form ****************** &&&&&&&&&&&&&&")
        self.replyTextField = UITextField(frame: CGRect(x: border, y: 0, width: self.view.frame.width-60-border, height: self.replyFormHeight))
        self.replyTextField?.backgroundColor = UIColor.whiteColor()
        //清除按钮
        self.replyTextField!.clearButtonMode = UITextFieldViewMode.Always;
        //键盘类型
        self.replyTextField!.keyboardType = UIKeyboardType.Default
        self.replyView?.addSubview(self.replyTextField!)
        
        self.replyButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        self.replyButton!.frame = CGRect(x: self.view.frame.width-60, y: 0, width: 60, height: self.replyFormHeight)
        self.replyButton?.setTitle("回复", forState: UIControlState.Normal)
        //self.replyButton?.backgroundColor = UIColor.grayColor()
        
        self.replyButton?.addTarget(self, action: "onReplyTopic:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.replyView?.addSubview(self.replyButton!)
        
    }
    
    func onReplyTopic(btn:UIButton) {
        var text = self.replyTextField?.text
        NSLog("begint reply : \(text)")
        var post = "{\"Content\":\"\(text)\", \"Topicid\":\"\(self.topic?.Id)\",  \"Pid\":0, \"Creatorid\":1}"

        
    }
    
    func addSplitLine() {
        // 画分割线
        var splitLable = UILabel(frame: CGRectMake(self.border, self.currentHeight, self.view.frame.width - 2 * self.border, 0.5))
        splitLable.backgroundColor = UIColor.grayColor()
        self.mainView?.addSubview(splitLable)
        self.currentHeight += self.border
    }
    
    func addContentView() {
        if let itemList = self.topic!.Content?.ItemList{
            for item in itemList {
                NSLog("addContentView run here \(item)")
                if item.Type == TopicDetailItemType.Text {
                    NSLog("addContentView add a text lable \(item.Data)")
                    var text = self.textStartSpace + item.Data!
                    var view = UILabel(frame: CGRect(x: self.border,
                        y: currentHeight,
                        width: self.mainView!.frame.width-2*self.border,
                        height: self.caculateLableHeight(text, fontSize: self.contentTextFontSize, showWidth: self.mainView!.frame.width - self.border*2)
                    ))
                    view.font = view.font.fontWithSize(self.contentTextFontSize)
                    view.lineBreakMode = NSLineBreakMode.ByCharWrapping
                    view.numberOfLines = 0
                    view.text = text
                    contentView.append(view)
                    self.mainView?.addSubview(view)
                    currentHeight += view.frame.height + self.border / 2
                } else if item.Type == TopicDetailItemType.Image {
                    NSLog("addContentView add a image \(item.Data)")
                    var view = UIImageView(frame: CGRect(x: self.border, y: currentHeight, width: self.mainView!.frame.width-2*self.border, height: self.contetnImageHeight))
                    var nsd = NSData(contentsOfURL: NSURL(string: item.Data!)!, options: NSDataReadingOptions.DataReadingUncached, error: nil)
                    if nsd != nil {
                        view.image = UIImage(data: nsd!)
                        view.layer.cornerRadius = self.contextCornerRadius
                        view.layer.masksToBounds = true
                        contentView.append(view)
                        self.mainView?.addSubview(view)
                        currentHeight += view.frame.height + self.border / 2
                    }
                } else {
                    NSLog("addContentView failed : unsupported of topicDetailItem \(item.Type)")
                }
                self.mainView?.contentSize = CGSizeMake(self.mainView!.frame.width, currentHeight)
            }
            NSLog("*************** current height : \(currentHeight)")
        }
    }
    
    func loadReplyListData() {
        replyListData = []
        var id:Int32 = self.topic!.Id!
        var url = NSURL(string:GetUrl("/reply?offset=\(0)&limit=\(self.replyPageSize)&query=topicid:\(id)"))
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
                    replyListData.append(reply)
                    NSLog("add a reply \(reply)")
                }
            }
            
             NSLog("errcode:\(errcode) errmsg:\(errmsg) data:\(retdata)")
        }
        
        addReplyListView()
    }
    
    func addReplyListView() {
        NSLog("************** current height : \(currentHeight)")
        NSLog("begin load reply list")
        var list = replyListData
        if list.count < 1 {
            return
        }
        for i in 0...list.count-1 {
            var reply = list[i]
            // 回复内容
            var text = reply.Content!
            var replyContent = UILabel(frame: CGRect(x: self.border,
                y: currentHeight,
                width: self.mainView!.frame.width-2*self.border,
                height: self.caculateLableHeight(text, fontSize: self.replyTextFontSize, showWidth: self.mainView!.frame.width - self.border*2)
                ))
            replyContent.font = replyContent.font.fontWithSize(self.replyTextFontSize)
            replyContent.textColor = UIColor.grayColor()
            replyContent.lineBreakMode = NSLineBreakMode.ByCharWrapping
            replyContent.numberOfLines = 0
            replyContent.text = text
            self.mainView?.addSubview(replyContent)
            currentHeight += replyContent.frame.height + self.border / 2
            
            // 回复时间
            text = GetPrintDateString(reply.Time)
            var replyTime = UILabel(frame: CGRect(x: self.border,
                y: currentHeight,
                width: self.mainView!.frame.width-2*self.border,
                height: self.caculateLableHeight(text, fontSize: self.replyTimeFontSize, showWidth: self.mainView!.frame.width - self.border*2)
                ))
            replyTime.font = replyTime.font.fontWithSize(self.replyTimeFontSize)
            replyTime.textColor = UIColor.grayColor()
            replyTime.lineBreakMode = NSLineBreakMode.ByCharWrapping
            replyTime.numberOfLines = 0
            replyTime.text = text
            self.mainView?.addSubview(replyTime)
            currentHeight += replyTime.frame.height + self.border / 2
            NSLog("add a reply success : \(text)")
            
            self.addSplitLine()
        }
        self.mainView?.contentSize = CGSizeMake(self.mainView!.frame.width, currentHeight)
    }
    
    // 计算文本框高度
    func caculateLableHeight(text: String, fontSize: CGFloat, showWidth: CGFloat) -> CGFloat {
        var sizeToFit:CGSize = NSString(string: text).boundingRectWithSize(
            CGSizeMake(showWidth, CGFloat(MAXFLOAT)),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName:UIFont.systemFontOfSize(fontSize)],
            context: nil).size
        return sizeToFit.height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDetailContent() {
        NSLog("详情 : \(self.topic?.Title)")
        //定义获取json数据的接口地址，这里定义的是获取天气的API接口,还有一个好处，就是swift语句可以不用强制在每条语句结束的时候用";"
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
        self.addContentView()
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
