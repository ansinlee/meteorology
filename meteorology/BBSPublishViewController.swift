
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
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        let title = (titleLabel.text as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let content = (textView.text as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if title.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || content.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            UIAlertView(title: "提示", message: "请输入完整的帖子信息", delegate: nil, cancelButtonTitle: "确定").show()
          return false
        }
        var abstract = content
        if (abstract.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)>50) {
            abstract = (abstract as NSString).substringToIndex(50)
        }
        
        var post = "{\"Content\":\"[{\\\"type\\\":0, data:\\\"\(content)\\\"}]\", \"Classid\":\(self.selectPedia),  \"Pid\":0, \"Creatorid\":\(GetCurrentUser().Id!)}"
        var url = NSURL(string: GetUrl("/topic"))
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("\(post.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField:"Content-Type")
        request.HTTPBody = post.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let postTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data: NSData!, resp: NSURLResponse!, err:NSError!)-> Void in
            NSLog("\(data) \(err) \(request.HTTPBody) \(resp)")
            if err == nil {
                UIAlertView(title: "提示", message: "网络异常", delegate: nil, cancelButtonTitle: "确定").show()
            }
        })
        postTask.resume()
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let title = (titleLabel.text as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let content = (textView.text as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }


}
