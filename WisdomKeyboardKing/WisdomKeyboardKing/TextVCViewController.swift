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
        bottomField.textOutputMode = .BankcardNumber19_4

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
        
        WisdomTextOutput.expiredTimeOutput(timesText: "1535557797", serverTimesText: nil, type: .timestamp)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.5) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -50)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func click() {
        print("------------------手势--------------------------------")
    }
}
