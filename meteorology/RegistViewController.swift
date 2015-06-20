//
//  RegistViewController.swift
//  meteorology
//
//  Created by LeeAnsin on 15/6/20.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit

class RegistViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var nickTextField: UITextField!
    @IBOutlet var iconTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPwdTextField: UITextField!
    @IBOutlet var errorMsgTextField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        errorMsgTextField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onRegist(sender: AnyObject) {
        let nick = nickTextField.text
        let icon = iconTextField.text
        let username = usernameTextField.text
        let password = passwordTextField.text
        let confirmpwd = confirmPwdTextField.text
        
        if nick == "" || icon == "" {
            errorMsgTextField.text = "昵称或头像不能为空"
            return
        }
        
        if username.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) < 6 || password.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) < 6 {
            errorMsgTextField.text = "用户密码太短"
            return
        }
        
        if password != confirmpwd {
            errorMsgTextField.text = "两次密码输入不一致"
            return
        }
        
        var post = "{\"Nick\":\"\(nick)\", \"Icon\":\"\(icon)\", \"Username\":\"\(username)\", \"Password\":\"\(password)\"}"
        
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            var url = NSURL(string: GetUrl("/user/register"))
            var request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            request.setValue("\(post.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))", forHTTPHeaderField: "Content-Length")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField:"Content-Type")
            request.HTTPBody = post.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            let postTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data: NSData!, resp: NSURLResponse!, err:NSError!)-> Void in
                NSLog("\(data) \(err) \(request.HTTPBody) \(resp)")
                if err == nil {
                    var json:AnyObject = NSJSONSerialization.JSONObjectWithData(data!,options:NSJSONReadingOptions.AllowFragments,error:nil)!
                    
                    //解析获取JSON字段值
                    var errcode:NSNumber = json.objectForKey("errcode") as! NSNumber //json结构字段名。
                    var errmsg:String? = json.objectForKey("errmsg") as? String
                    var retdata:NSArray? = json.objectForKey("data") as? NSArray
                    NSLog("errcode:\(errcode) errmsg:\(errmsg) data:\(retdata)")
                    dispatch_async(dispatch_get_main_queue()) {
                        if errcode == 0 {
                            UIAlertView(title: "提示", message: "注册成功", delegate: nil, cancelButtonTitle: "确定").show()
                            self.navigationController?.popViewControllerAnimated(true)
                        } else {
                            UIAlertView(title: "提示", message: "注册失败", delegate: nil, cancelButtonTitle: "确定").show()
                        }
                    }
                    
                   
                }
            })
            postTask.resume()
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
