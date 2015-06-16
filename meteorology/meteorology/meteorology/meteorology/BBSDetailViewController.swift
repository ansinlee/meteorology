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
    let abstractFontSize = CGFloat(13)
    let contentTextFrontSize = CGFloat(14)
    let contetnImageHeight = CGFloat(200)
    let textStartSpace = "       "
    let contextCornerRadius = CGFloat(8)
    
    var mainView: UIScrollView?
    var titleLable: UILabel?
    var abstractLable:UILabel?
    var contentView: [UIView] = []
    var topic: Topic?
    
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
        
        // 添加主景
        self.mainView = UIScrollView(frame: CGRect(x: -1, y: UIApplication.sharedApplication().statusBarFrame.height + self.navigationController!.navigationBar.frame.height, width: self.view.frame.width+2, height: self.view.frame.height - UIApplication.sharedApplication().statusBarFrame.height - self.navigationController!.navigationBar.frame.height - BottomNavBarHeight))
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
        
        // 添加摘要
        self.abstractLable = UILabel(frame: CGRect(
            x: self.border,
            y: self.titleLable!.frame.origin.y + self.titleLable!.frame.height + self.border,
            width: self.mainView!.frame.width - self.border*2,
            height: self.caculateLableHeight(self.textStartSpace + self.topic!.Abstract! , fontSize: CGFloat(self.abstractFontSize), showWidth: self.mainView!.frame.width - self.border*4) + 20
        ))
        self.abstractLable?.font = self.abstractLable!.font.fontWithSize(self.abstractFontSize)
        self.abstractLable?.lineBreakMode = NSLineBreakMode.ByCharWrapping
        self.abstractLable?.numberOfLines = 0
        self.abstractLable?.backgroundColor = MainBackgroudColor
        self.abstractLable?.layer.cornerRadius = self.contextCornerRadius
        self.abstractLable?.layer.masksToBounds = true
        self.abstractLable?.text = self.textStartSpace + self.topic!.Abstract!
        self.mainView?.addSubview(self.abstractLable!)
        
        // 禁用自动布局
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 画分割线
        var splitLable = UILabel(frame: CGRectMake(self.border, self.abstractLable!.frame.origin.y+self.abstractLable!.frame.height + self.border / 2, self.view.frame.width - 2 * self.border, 2))
        splitLable.backgroundColor = UIColor.grayColor()
        self.mainView?.addSubview(splitLable)
        
        
        // 添加正文
        self.loadDetailContent()
    }

    func addContentView() {
        var currentHeight = self.abstractLable!.frame.origin.y + self.abstractLable!.frame.height + self.border
        if let itemList = self.topic!.Content?.ItemList{
            for item in itemList {
                NSLog("addContentView run here \(item)")
                if item.Type == TopicDetailItemType.Text {
                    NSLog("addContentView add a text lable \(item.Data)")
                    var text = self.textStartSpace + item.Data!
                    var view = UILabel(frame: CGRect(x: self.border,
                        y: currentHeight,
                        width: self.mainView!.frame.width-2*self.border,
                        height: self.caculateLableHeight(text, fontSize: self.contentTextFrontSize, showWidth: self.mainView!.frame.width - self.border*2)
                    ))
                    view.font = view.font.fontWithSize(self.contentTextFrontSize)
                    view.lineBreakMode = NSLineBreakMode.ByCharWrapping
                    view.numberOfLines = 0
                    view.text = text
                    contentView.append(view)
                    self.mainView?.addSubview(view)
                    currentHeight += view.frame.height + self.border / 2
                } else if item.Type == TopicDetailItemType.Image {
                    NSLog("addContentView add a image \(item.Data)")
                    var view = UIImageView(frame: CGRect(x: self.border, y: currentHeight, width: self.mainView!.frame.width-2*self.border, height: self.contetnImageHeight))
                    view.image = UIImage(named: item.Data!)
                    view.layer.cornerRadius = self.contextCornerRadius
                    view.layer.masksToBounds = true
                    contentView.append(view)
                    self.mainView?.addSubview(view)
                    currentHeight += view.frame.height + self.border / 2
                } else {
                    NSLog("addContentView failed : unsupported of topicDetailItem \(item.Type)")
                }
                self.mainView?.contentSize = CGSizeMake(self.mainView!.frame.width, currentHeight)
            }
        }
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
