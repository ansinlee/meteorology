//
//  PediaSearchViewController.swift
//  meteorology
//
//  Created by LeeAnsin on 15/3/21.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit

class PediaSearchViewController: UITableViewController, UISearchBarDelegate {
    
    var currentDataSource:[Subject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        PediaListProvider.searchData(searchBar.text) {
            subjects in
            self.currentDataSource = subjects
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.currentDataSource = []
        self.tableView.reloadData()
        searchBar.endEditing(true)
    }

    // MARK: tabelview delegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentDataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? UITableViewCell {
            let subject = currentDataSource[indexPath.row]
            if subject.Img == nil {
                (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "default")
            }
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
            (cell.viewWithTag(2) as! UILabel).text = subject.Title
            (cell.viewWithTag(3) as! UILabel).text = subject.Abstract
            
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if indexPath.row < currentDataSource.count {
            let subject = currentDataSource[indexPath.row]
            let detailVC = PediaDetailViewController(subject: subject)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
