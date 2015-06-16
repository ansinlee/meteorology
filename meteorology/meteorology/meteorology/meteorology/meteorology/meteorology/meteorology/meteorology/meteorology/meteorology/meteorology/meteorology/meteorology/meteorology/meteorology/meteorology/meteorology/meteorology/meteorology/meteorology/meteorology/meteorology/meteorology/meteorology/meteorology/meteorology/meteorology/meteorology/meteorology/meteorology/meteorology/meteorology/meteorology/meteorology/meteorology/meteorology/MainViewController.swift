//
//  MainViewController.swift
//  meteorology
//
//  Created by LeeAnsin on 15/3/21.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    let kScreenWidth:CGFloat = UIScreen.mainScreen().bounds.size.width
    let kScreenHeight:CGFloat = UIScreen.mainScreen().bounds.size.height
    let tabViewHeight:CGFloat = BottomNavBarHeight
    let btnWidth:CGFloat = UIScreen.mainScreen().bounds.size.width / 3
    let btnHeight:CGFloat = 36
    
    let navBtnPicArray = ["nav_pedia_normal.png","nav_bbs_normal.png","nav_prof_normal.png",
"nav_pedia_selected.png","nav_bbs_selected.png","nav_prof_selected.png"]
    var navBtnArray:NSMutableArray = NSMutableArray(capacity: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tabBar.hidden = true
        self.initVeiwController()
        self.initTabBarView()
    }
    
    // 初始化视图控制器
    func initVeiwController() {
        // 初始化各个视图控制器
        var vcArray = [PediaViewController(), BBSViewController(), ProfViewController()]
        
        // 初始化导航控制器
        var tabArray = NSMutableArray(capacity: vcArray.count)
        for vc in vcArray {
            tabArray.addObject(UINavigationController(rootViewController: vc))
        }
        
        // 将导航控制器给标签控制器
        self.viewControllers = tabArray as [AnyObject]
        
    }
    
    // 自定义工具栏
    func initTabBarView() {
        // 初始化标签工具栏视图
        var _tabBarView = UIView(frame: CGRect(x: 0, y: kScreenHeight-tabViewHeight, width: kScreenHeight, height: tabViewHeight))
        _tabBarView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(_tabBarView)
        
        // 创建导航按钮
        for i in 0..<navBtnPicArray.count/2 {
            var btn: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            btn.removeConstraints(btn.constraints());
            btn.setBackgroundImage(UIImage(named: navBtnPicArray[(i==0) ? (i+navBtnPicArray.count/2) : i] as String), forState: UIControlState.Normal)
            btn.frame = CGRectMake(btnWidth * CGFloat(i), (tabViewHeight - btnHeight) / 2, btnWidth, btnHeight)
            btn.tag = 100 + i
            btn.addTarget(self, action: "navSelectBtnAction:" , forControlEvents: UIControlEvents.TouchUpInside)
            
            _tabBarView.addSubview(btn)
            navBtnArray.addObject(btn)
        }
    }
    
    // 导航按钮点击事件
    func navSelectBtnAction(btn:UIButton) {
        self.selectedIndex = btn.tag - 100
        for i in 0..<navBtnArray.count {
            var index = (navBtnArray[i] as! UIButton).tag - 100
            navBtnArray[i].setBackgroundImage(UIImage(named: navBtnPicArray[(self.selectedIndex == index) ? (index+navBtnArray.count) : index] as String), forState: UIControlState.Normal)
        }
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
