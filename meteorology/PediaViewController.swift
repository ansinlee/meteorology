//
//  PediaViewController.swift
//  meteorology
//
//  Created by LeeAnsin on 15/3/21.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit

class PediaViewController: UITableViewController {

    let searchBtnWidth:CGFloat = 33
    let searchBtnHeight:CGFloat = 32
    
    let kScreenWidth:CGFloat = UIScreen.mainScreen().bounds.size.width
    let kScreenHeight:CGFloat = UIScreen.mainScreen().bounds.size.height
    let btnWidth:CGFloat = 50
    let btnHeight:CGFloat = 40
    
    var collectionView:UICollectionView!
    
    var activityIndicator:UIActivityIndicatorView!
    
    var currentDataSource:[Subject] = []
    
    var currentSelectPedia = 0 {
        didSet {
            
            if CGFloat(currentSelectPedia*60) > collectionView.frame.width/2 {
                var offset = CGFloat(currentSelectPedia*60) -  collectionView.frame.width/2
                if collectionView.contentSize.width - offset > collectionView.frame.width - 60 {
                    collectionView.contentOffset = CGPointMake(offset , 0)
                }
            }
            
            if currentSelectPedia == 0 {
                collectionView.contentOffset = CGPointZero
            }
            
            if currentSelectPedia > oldValue {
                let anim:CATransition = CATransition()
                anim.type = "push"
                anim.subtype = "fromRight"
                anim.duration = 0.3
                for cell in tableView.visibleCells() {
                    cell.layer.addAnimation(anim, forKey: "animate")
                }
            } else {
                let anim:CATransition = CATransition()
                anim.type = "push"
                anim.subtype = "fromLeft"
                 anim.duration = 0.3
                for cell in tableView.visibleCells() {
                    cell.layer.addAnimation(anim, forKey: "animate")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        PediaListProvider.loadClasses()
        super.viewDidLoad()
        self.initHeaderView()
        self.view.backgroundColor = UIColor.whiteColor()
        tableView.tableFooterView = UIView()
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.center = CGPoint(x: tableView.frame.width/2, y: tableView.frame.height/2)
        activityIndicator.startAnimating()
        self.tableView.addSubview(activityIndicator)
        PediaListProvider.loadPediaData(PediaListProvider.ClassIds[currentSelectPedia]) {
            subjects in
            self.activityIndicator.hidden = true
            self.currentDataSource = subjects
            self.tableView.reloadData()
        }
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: "swipeLeft")
        leftSwipe.direction = .Left
        self.tableView.addGestureRecognizer(leftSwipe)
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: "swipeRight")
        rightSwipe.direction = .Right
        self.tableView.addGestureRecognizer(rightSwipe)
    }
    
    override func viewWillDisappear(animated: Bool) {
        activityIndicator.stopAnimating()
    }
    
    func initHeaderView() {
        let flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSizeMake(60, 30)
        flowLayout.scrollDirection = .Horizontal
        collectionView = UICollectionView(frame: CGRectMake(0, 0, tableView.frame.size.width, 30), collectionViewLayout: flowLayout)
        collectionView.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        self.tableView.tableHeaderView = collectionView
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        let underLine = UIView(frame:  CGRectMake(-100, 29.5, 2*tableView.frame.size.width+100, 0.5))
        underLine.backgroundColor = UIColor.lightGrayColor()
        collectionView.addSubview(underLine)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.refreshControl?.frame =  CGRectMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y+94, self.tableView.frame.width, 80)
        self.collectionView.frame = CGRectMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y+64, self.tableView.frame.width, 30)
    }
    
    // MARK: control methods
    
    @IBAction func onRefresh(sender: UIRefreshControl) {
        sender.endRefreshing()
    }
    
    @IBAction func onSearch(sender: AnyObject) {
        
    }
    
    func swipeRight() {
        self.refreshControl?.endRefreshing()
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        if currentSelectPedia > 0 {
            currentSelectPedia--
            collectionView.reloadData()
            PediaListProvider.loadPediaData(PediaListProvider.ClassIds[currentSelectPedia]) {
                subjects in
                self.activityIndicator.hidden = true
                self.currentDataSource = subjects
                self.tableView.reloadData()
            }
        }
    }
    
    func swipeLeft() {
        self.refreshControl?.endRefreshing()
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        if currentSelectPedia < PediaListProvider.Classes.count - 1 {
            currentSelectPedia++
            collectionView.reloadData()
            PediaListProvider.loadPediaData(PediaListProvider.ClassIds[currentSelectPedia]) {
                subjects in
                self.activityIndicator.hidden = true
                self.currentDataSource = subjects
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: tabelview delegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentDataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("mainsubjectcell", forIndexPath: indexPath) as? UITableViewCell {
            let subject = currentDataSource[indexPath.row]
            (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "default")
            dispatch_async(dispatch_get_global_queue(0, 0)) {
                var data = NSData(contentsOfURL: NSURL(string: subject.Img!)!)
                dispatch_async(dispatch_get_main_queue()) {
                    if data != nil {
                        (cell.viewWithTag(1) as! UIImageView).image = UIImage(data: data!)
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
            //detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
   
}

// MARK: 给上面的标题栏提供的样式

extension PediaViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PediaListProvider.Classes.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as? UICollectionViewCell {
            var underLine:UIView? = cell.viewWithTag(2)
            if underLine == nil {
                underLine = UIView(frame: CGRectMake(0, 28, 60, 2))
                underLine!.backgroundColor = UIColor.redColor()
                underLine!.hidden = true
                underLine!.tag = 2
                cell.addSubview(underLine!)
            }
            var label:UILabel? = cell.viewWithTag(1) as? UILabel
            if label == nil {
                label = UILabel(frame: CGRectMake(0, 0, 60, 30))
                label!.textColor = UIColor.darkTextColor()
                label!.tag = 1
                label!.textAlignment = .Center
                cell.addSubview(label!)
            }
            label!.text = PediaListProvider.Classes[indexPath.item]
            if currentSelectPedia == indexPath.item {
                label!.font = UIFont.boldSystemFontOfSize(16)
                underLine?.hidden = false
            } else {
                label!.font = UIFont.systemFontOfSize(14)
                underLine?.hidden = true
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.refreshControl?.endRefreshing()
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        if currentSelectPedia != indexPath.item {
            currentSelectPedia = indexPath.item
            collectionView.reloadData()
            PediaListProvider.loadPediaData(PediaListProvider.ClassIds[currentSelectPedia]) {
                subjects in
                self.activityIndicator.hidden = true
                self.currentDataSource = subjects
                self.tableView.reloadData()
            }
        }
    }
}
