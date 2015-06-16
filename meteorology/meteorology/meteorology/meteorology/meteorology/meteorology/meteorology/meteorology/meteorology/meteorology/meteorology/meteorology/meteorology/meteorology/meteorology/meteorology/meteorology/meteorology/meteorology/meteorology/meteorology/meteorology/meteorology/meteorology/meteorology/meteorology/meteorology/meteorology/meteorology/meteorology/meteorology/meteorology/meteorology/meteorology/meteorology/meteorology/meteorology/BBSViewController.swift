//
//  BBSViewController.swift
//  meteorology
//
//  Created by LeeAnsin on 15/3/21.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit

class BBSViewController: UIViewController {

    let searchBtnWidth:CGFloat = 33
    let searchBtnHeight:CGFloat = 32
    
    let kScreenWidth:CGFloat = UIScreen.mainScreen().bounds.size.width
    let kScreenHeight:CGFloat = UIScreen.mainScreen().bounds.size.height
    let btnWidth:CGFloat = 50
    let btnHeight:CGFloat = 40
    
    var classListView:BBSListView?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "互动社区"
        
        // 打开子返回只有一个箭头
        var backButtonBar = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonBar
        
        // 设置导航字体为白色
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(),
            forKey:NSForegroundColorAttributeName) as [NSObject : AnyObject]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = NavBarBackgroudColor
        
        // 设置背景色
        self.view.backgroundColor = NavBarBackgroudColor
        
        // 添加分类导航条
        self.initclassNavBar()
        
        // 添加列表页
        self.initClassListView()
        
        // 禁用自动布局
        self.automaticallyAdjustsScrollViewInsets = false

    }
    
    // 分类导航条
    func initclassNavBar() {
        var navBar = UIScrollView(frame: CGRect(x: 0, y: UIApplication.sharedApplication().statusBarFrame.height + self.navigationController!.navigationBar.frame.height, width: kScreenWidth, height: btnHeight))
        navBar.backgroundColor = UIColor.clearColor()
        navBar.showsHorizontalScrollIndicator = false
        //navBar.userInteractionEnabled = true
        //navBar.panGestureRecognizer.delaysTouchesBegan = true
        
        var classesList:[Class] = GetClassesList()
        for i in 0..<classesList.count {
            var btn = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            btn.frame = CGRectMake(CGFloat(i)*btnWidth, 0, btnWidth, btnHeight)
            btn.tag = 200 + Int(classesList[i].Id)
            btn.backgroundColor = UIColor.whiteColor()
            btn.setTitleColor(NavBarBackgroudColor, forState: UIControlState.Normal)
            btn.setTitle(classesList[i].Name, forState: UIControlState.Normal)
            btn.addTarget(self, action: "classNavBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            navBar.addSubview(btn)
        }
        
        navBar.contentSize = CGSizeMake(btnWidth*CGFloat(classesList.count), btnHeight)
        //navBar.setContentOffset(CGPointMake(0, 0), animated: true)
        self.view.addSubview(navBar)
    }
    
    // 分类导航按钮点击事件
    func classNavBtnClicked(btn: UIButton) {
        classListView!.loadListData(btn.tag - 200)
    }
    
    func initClassListView() {
        classListView = BBSListView(frame: CGRect(x: 0, y: UIApplication.sharedApplication().statusBarFrame.height + self.navigationController!.navigationBar.frame.height + btnHeight, width: kScreenWidth, height: self.view.frame.height - (UIApplication.sharedApplication().statusBarFrame.height + self.navigationController!.navigationBar.frame.height + btnHeight + btnHeight)))
        classListView?.parentVC = self
        self.view.addSubview(classListView!)
        classListView!.loadListData(1);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
