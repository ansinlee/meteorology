//
//  PediaListTableViewCell.swift
//  meteorology
//
//  Created by LeeAnsin on 15/3/28.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit

class PediaListTableViewCell: UITableViewCell {

    var id: Int32!
    var imgView: UIImageView!
    var title: UILabel!
    var abstract: UILabel!
    
    let border:CGFloat = 3
    let imageWidth:CGFloat = 120
    let imageHeight:CGFloat = 115
    let cellHeight:CGFloat = 120
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = MainBackgroudColor

        // 为什么self.frame.width 在iphone6plus上为320
        var frame: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: self.cellHeight - self.border*1.5))
        self.addSubview(frame)
        frame.backgroundColor = UIColor.whiteColor()
        //frame.layer.cornerRadius = MainCornerRadius
        //frame.layer.masksToBounds = true
        //frame.layer.borderWidth = MainBorderWidth
        frame.layer.borderWidth = 0
        frame.layer.borderColor = NavBarBackgroudColor.CGColor
        
        self.imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        self.imgView.backgroundColor = UIColor.lightGrayColor()
        self.imgView.contentMode = UIViewContentMode.ScaleToFill;
        frame.addSubview(self.imgView)
        
        var contentView = UIView(frame: CGRect(x: imageWidth + border*3, y: border, width: frame.frame.width-imageWidth-3*border, height: imageHeight))
        frame.addSubview(contentView)
        
        title = UILabel(frame: CGRect(x: 0, y: 10, width: contentView.frame.width, height: contentView.frame.height * 0.2))
        abstract = UILabel(frame: CGRect(x: 0, y: contentView.frame.height * 0.2 + border, width: contentView.frame.width, height: contentView.frame.height * 0.8 - 2 * border))
        abstract.lineBreakMode = NSLineBreakMode.ByCharWrapping
        abstract.numberOfLines = 0
        abstract.font = abstract.font.fontWithSize(14)
        contentView.addSubview(title)
        contentView.addSubview(abstract)
        
    }
    
    func setData(id: Int32, img: UIImage, title: String, abstract: String) {
        self.id = id
        self.imgView?.image = img
        self.title.text = title
        var abst = abstract
        if (abstract as NSString).length > 52 {
            abst = (abstract as NSString).substringToIndex(52) + "..."
        }
        self.abstract.text = abst
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
