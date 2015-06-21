//
//  PediaDetailViewController.swift
//  meteorology
//
//  Created by LeeAnsin on 15/3/22.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit

class PediaDetailViewController: UIViewController {
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
    var subject: Subject?
    
    init(subject:Subject?) {
        super.init(nibName: nil, bundle: nil)
        self.subject = subject
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
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "详情"
        
        // 添加主景
        self.mainView = UIScrollView(frame: CGRect(x: -1, y: UIApplication.sharedApplication().statusBarFrame.height + self.navigationController!.navigationBar.frame.height, width: self.view.frame.width+2, height: self.view.frame.height - UIApplication.sharedApplication().statusBarFrame.height - self.navigationController!.navigationBar.frame.height - BottomNavBarHeight))

        self.view.addSubview(self.mainView!)
        
        // 添加标题
        self.titleLable = UILabel(frame: CGRect(x: self.border, y: self.border, width: self.mainView!.frame.width - self.border*2, height: self.caculateLableHeight(self.textStartSpace + self.subject!.Title! , fontSize: CGFloat(self.titleFontSize), showWidth: self.mainView!.frame.width - self.border*4)))
        self.titleLable?.lineBreakMode = NSLineBreakMode.ByCharWrapping
        self.titleLable?.numberOfLines = 0
        self.titleLable?.font = self.titleLable!.font.fontWithSize(self.titleFontSize)
        self.titleLable?.textAlignment = NSTextAlignment.Center
        self.titleLable?.text = subject?.Title
        self.mainView?.addSubview(self.titleLable!)
        
        // 添加摘要
        self.abstractLable = UILabel(frame: CGRect(
            x: self.border,
            y: self.titleLable!.frame.origin.y + self.titleLable!.frame.height + self.border,
            width: self.mainView!.frame.width - self.border*2,
            height: self.caculateLableHeight(self.textStartSpace + self.subject!.Abstract! , fontSize: CGFloat(self.abstractFontSize), showWidth: self.mainView!.frame.width - self.border*4) + 20
        ))
        self.abstractLable?.font = self.abstractLable!.font.fontWithSize(self.abstractFontSize)
        self.abstractLable?.lineBreakMode = NSLineBreakMode.ByCharWrapping
        self.abstractLable?.numberOfLines = 0
        self.abstractLable?.backgroundColor = MainBackgroudColor
        self.abstractLable?.layer.cornerRadius = self.contextCornerRadius
        self.abstractLable?.layer.masksToBounds = true
        self.abstractLable?.text = self.textStartSpace + self.subject!.Abstract!
        self.mainView?.addSubview(self.abstractLable!)
        
        // 禁用自动布局
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 画分割线
        var splitLable = UILabel(frame: CGRectMake(self.border, self.abstractLable!.frame.origin.y+self.abstractLable!.frame.height + self.border / 2, self.view.frame.width - 2 * self.border, 0.5))
        splitLable.backgroundColor = UIColor.grayColor()
        self.mainView?.addSubview(splitLable)
        
        
        // 添加正文
        self.loadDetailContent()
    }

    func addContentView() {
        var currentHeight = self.abstractLable!.frame.origin.y + self.abstractLable!.frame.height + self.border
        if let itemList = self.subject!.Content?.ItemList{
            for item in itemList {
                NSLog("addContentView run here \(item)")
                if item.Type == SubjectDetailItemType.Text {
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
                } else if item.Type == SubjectDetailItemType.Image {
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
                    NSLog("addContentView failed : unsupported of SubjectDetailItem \(item.Type)")
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
        NSLog("详情 : \(self.subject?.Title)")
        /*
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            var id:Int32 = self.subject!.Id!
            var url = NSURL(string:GetUrl("/subject/\(id)"))
            //获取JSON数据
            var data = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingUncached, error: nil)
            var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data!,options:NSJSONReadingOptions.AllowFragments,error:nil)!
            
            //解析获取JSON字段值
            var errcode:NSNumber = json.objectForKey("errcode") as! NSNumber //json结构字段名。
            var errmsg:String? = json.objectForKey("errmsg") as? String
            var retdata:NSDictionary? = json.objectForKey("data") as? NSDictionary
            NSLog("errcode:\(errcode) errmsg:\(errmsg) data:\(retdata)")
            
            if errcode == 0 {
                self.subject?.Content = SubjectDetailContent(data: retdata?.objectForKey("Content"))
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.addContentView()
            }
        }
        */
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
