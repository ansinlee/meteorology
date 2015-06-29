
//
//  BBSPublishViewController.swift
//  meteorology
//
//  Created by 诺崇 on 15/6/18.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit
import PhotosUI

class BBSPublishViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var selectPedia:Int = 0

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var titleLabel: UITextField!
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    var loadPublishFinish = false
    
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
    @IBAction func onChoosePhoto(sender: AnyObject) {
        UIActionSheet(title: "照片", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles:"拍摄照片","从相册选择").showInView(view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            return;
        }
        let imagePicker = UIImagePickerController()
        if buttonIndex == 1 {
            imagePicker.sourceType = .Camera
        } else if buttonIndex == 2 {
            imagePicker.sourceType = .PhotoLibrary
        }
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let orginimage = info[UIImagePickerControllerOriginalImage] as! UIImage
        var size = CGSize(width: orginimage.size.width/8, height: orginimage.size.height/8)
        UIGraphicsBeginImageContext(size)
        orginimage.drawInRect(CGRect(origin: CGPointZero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        previewImageView.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if loadPublishFinish == true {
            return true
        }
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
        
        // TODO: 从previewImageView里面拿到Image 上传
        
        var post = "{\"Content\":\"[{\\\"type\\\":0, \\\"data\\\":\\\"\(content)\\\"}]\", \"title\":\"\(title)\", \"abstract\":\"\(abstract)\", \"Classid\":\(self.selectPedia),  \"Pid\":0, \"Creatorid\":\(GetCurrentUser().Id!)}"
        var url = NSURL(string: GetUrl("/topic"))
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("\(post.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField:"Content-Type")
        request.HTTPBody = post.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let postTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data: NSData!, resp: NSURLResponse!, err:NSError!)-> Void in
            NSLog("\(data) \(err) \(request.HTTPBody) \(resp)")
            dispatch_async(dispatch_get_main_queue()) {
                if err != nil {
                    UIAlertView(title: "提示", message: "网络异常", delegate: nil, cancelButtonTitle: "确定").show()
                } else {
                    self.loadPublishFinish = true
                    self.performSegueWithIdentifier("unwind", sender: sender)
                }
            }
        })
        postTask.resume()
        
        return false
    }
    
}
