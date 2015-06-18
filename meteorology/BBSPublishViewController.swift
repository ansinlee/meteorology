
//
//  BBSPublishViewController.swift
//  meteorology
//
//  Created by 诺崇 on 15/6/18.
//  Copyright (c) 2015年 LeeAnsin. All rights reserved.
//

import UIKit

class BBSPublishViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var titleLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.becomeFirstResponder()
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
