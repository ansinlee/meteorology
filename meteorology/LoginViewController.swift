//
//  LoginViewController.swift
//  meteorology
//
//  Created by LeeAnsin on 15/6/20.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var logoutBtn: UIButton!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var registerBtn: UIButton!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var errmsgLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        flushUI()
    }
    
    func flushUI() {
        if CheckIsLogin() {
            usernameTextField.hidden = true
            usernameLabel.hidden = true
            passwordTextField.hidden = true
            passwordLabel.hidden = true
            registerBtn.hidden = true
            loginBtn.hidden = true
            errmsgLabel.hidden = true
            logoutBtn.hidden = false
        } else {
            usernameTextField.hidden = false
            usernameLabel.hidden = false
            passwordTextField.hidden = false
            passwordLabel.hidden = false
            registerBtn.hidden = false
            loginBtn.hidden = false
            loginBtn.hidden = false
            logoutBtn.hidden = true
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        errmsgLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        if username=="" || password=="" {
            errmsgLabel.text = "用户名或密码不能为空"
            return
        }
        
        var post = "{\"Username\":\"\(username)\", \"Password\":\"\(password)\"}"
        
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            var url = NSURL(string: GetUrl("/user/login"))
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
                    var retdata: AnyObject? = json.objectForKey("data")
                    NSLog("errcode:\(errcode) errmsg:\(errmsg) data:\(retdata)")
                    dispatch_async(dispatch_get_main_queue()) {
                        if errcode == 0 {
                            UIAlertView(title: "提示", message: "登录成功", delegate: nil, cancelButtonTitle: "确定").show()
                            Login(User(data: retdata))
                            self.flushUI()
                            self.navigationController?.popViewControllerAnimated(true)
                        } else {
                            self.errmsgLabel.text = "用户名或密码错误"
                        }
                    }
                    
                    
                }
            })
            postTask.resume()
        }
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        Logout()
        self.navigationController?.popViewControllerAnimated(true)
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
