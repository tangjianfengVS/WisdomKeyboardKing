//
//  TextVCViewController.swift
//  LongYuWarriors
//
//  Created by jianfeng on 2018/8/11.
//  Copyright © 2018年 AllOverTheSkyStar. All rights reserved.
//

import UIKit

class TextVCViewController: UIViewController {
    @IBOutlet weak var bottomField: UITextField!
    @IBOutlet weak var bottomTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bottomField.wisdomTask(beginTasks: { (view, title, rect) in
            //print(view,title,rect)
        }, changeTasks: { (view, title, rect) in
            //print(view,title,rect)
        }) { (view, title, rect) in
            //print(view,title,rect)
        }
        
        bottomTextView.wisdomTask(beginTasks: { (view, title, rect) in
            //print(view,title,rect)
        }, changeTasks: { (view, title, rect) in
            //print(view,title,rect)
        }) { (view, title, rect) in
            //print(view,title,rect)
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func click() {
        print("------------------手势--------------------------------")
    }
}