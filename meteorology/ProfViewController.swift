//
//  ProfViewController.swift
//  meteorology
//
//  Created by LeeAnsin on 15/3/21.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit

class ProfViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "个人信息"
        
        // 设置导航字体为白色
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(),
            forKey:NSForegroundColorAttributeName) as [NSObject : AnyObject]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = NavBarBackgroudColor
        
        // 设置背景色
        self.view.backgroundColor = MainBackgroudColor
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
