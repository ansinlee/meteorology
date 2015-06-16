//
//  PediaSearchViewController.swift
//  meteorology
//
//  Created by LeeAnsin on 15/3/21.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit

class PediaSearchViewController: UIViewController, UISearchBarDelegate {
    var searchBar: UISearchBar?
    var searchView: PediaListView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(),
            forKey:NSForegroundColorAttributeName) as [NSObject : AnyObject]
        self.view.backgroundColor = MainBackgroudColor
        
        // 打开子神力返回只有一个箭头
        var backButtonBar = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonBar
        
        // 添加搜索框
        self.addSearchBar()
        
        self.addSearchResultView()
    }

    func addSearchBar() {
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.navigationController!.navigationBar.frame.width, height: self.navigationController!.navigationBar.frame.height))
        self.searchBar?.delegate = self
        self.searchBar?.placeholder = "搜索"
        self.searchBar?.autocapitalizationType = UITextAutocapitalizationType.None
        self.navigationItem.titleView = self.searchBar
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        for subView in searchBar.subviews[0].subviews {
            if subView.isKindOfClass(UIButton) {
                (subView as! UIButton).setTitle("取消", forState: UIControlState.Normal)
            }
        }
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar?.showsScopeBar = true
        self.searchBar?.sizeToFit()
        self.searchBar?.showsCancelButton = true
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar?.showsScopeBar = false
        self.searchBar?.sizeToFit()
        self.searchBar?.showsCancelButton = false
        self.searchBar?.resignFirstResponder()
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar?.showsScopeBar = false
        self.searchBar?.sizeToFit()
        self.searchBar?.showsCancelButton = false
        self.searchBar?.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar?.resignFirstResponder()
        var query = self.searchBar?.text
        self.searchView?.searchData(query!)
    }
    
    func addSearchResultView() {
        self.searchView = PediaListView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.searchView?.parentVC = self
        self.view.addSubview(self.searchView!)
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
