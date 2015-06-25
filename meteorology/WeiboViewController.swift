//
//  WeiboViewController.swift
//  meteorology
//
//  Created by LeeAnsin on 15/6/26.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit

class WeiboViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var weiboWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.weiboWebView.delegate = self
        self.weiboWebView.loadRequest(NSURLRequest(URL: NSURL(string: "http://show.v.t.qq.com/index.php?c=show&a=index&n=fyqx58203&w=260&h=315&fl=1&l=4&o=25&co=0")!))
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.weiboWebView.delegate = nil
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.weiboWebView.stringByEvaluatingJavaScriptFromString("document.body.style.zoom=1.25")
        
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
