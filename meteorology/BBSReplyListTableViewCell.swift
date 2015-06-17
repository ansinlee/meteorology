//
//  PediaListTableViewCell.swift
//  meteorology
//
//  Created by LeeAnsin on 15/3/28.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit

class BBSReplyListTableViewCell: UITableViewCell {
    var reply:Reply!
    
    var id: Int32!
    var time:UILabel!
    var userIcon:UIImageView!
    var userNick:UILabel!
    var dateFormatter:NSDateFormatter!

    let border:CGFloat = 3
    let cellHeight:CGFloat = 80
    let userInfoHeight:CGFloat = 24
    let titleHeight:CGFloat = 20
    let abstractHeight:CGFloat = 20
    let timeHeight:CGFloat = 20

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.whiteColor()
        NSLog("*****BBSListTableViewCell init here")
        
        // 用户信息栏
        var userFrame: UIView = UIView(frame: CGRect(x: 0, y: border, width: UIScreen.mainScreen().bounds.size.width, height: userInfoHeight))
        self.addSubview(userFrame)
        self.userIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: userInfoHeight, height: userInfoHeight))
        self.userIcon.backgroundColor = UIColor.whiteColor()
        self.userIcon.contentMode = UIViewContentMode.ScaleToFill;
        userFrame.addSubview(self.userIcon)
        self.userNick = UILabel(frame: CGRect(x: userInfoHeight + border, y: 0, width: userFrame.frame.size.width-userInfoHeight, height: userInfoHeight))
        userNick.lineBreakMode = NSLineBreakMode.ByCharWrapping
        userNick.numberOfLines = 0
        userNick.font = userNick.font.fontWithSize(10)
        userNick.textColor = UIColor.grayColor()
        userFrame.addSubview(userNick)
        
        // 添加列表信息中的标题和摘要
        var contentView = UIView(frame: CGRect(x: border*3, y: userInfoHeight, width: self.frame.width-3*border, height: cellHeight-userInfoHeight))
        self.addSubview(contentView)
        
        time = UILabel(frame: CGRect(x: 0, y: 6+titleHeight+abstractHeight, width: contentView.frame.width, height: timeHeight))
        time.font = time.font.fontWithSize(10)
        time.textColor = UIColor.grayColor()
        contentView.addSubview(time)
        NSLog("*****BBSListTableViewCell init end")
        
    }
    
    func setData(r:Reply) {
        self.reply = r
        self.id = r.Id
        //self.time.text = self.dateFormatter.stringFromDate(r.Time!)
        if r.Creator != nil {
            userNick.text = r.Creator?.Nick
            if r.Creator?.Icon != nil {
                userIcon.image = r.Creator?.Icon
            }
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
