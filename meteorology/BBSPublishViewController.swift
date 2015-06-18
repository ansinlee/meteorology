
//
//  BBSPublishViewController.swift
//  meteorology
//
//  Created by 诺崇 on 15/6/18.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit

class BBSPublishViewController: UIViewController {
    
    var selectPedia:Int = 0

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var titleLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.becomeFirstResponder()
//        textView.layer.borderWidth = 0.5
//        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
//        textView.layer.cornerRadius = 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onPublish(sender: AnyObject) {
        let title = (titleLabel.text as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let content = (textView.text as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if title.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 && content.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            // TODO : publish 
            
        } else {
            UIAlertView(title: "提示", message: "请输入完整的帖子信息", delegate: nil, cancelButtonTitle: "确定").show()
        }
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