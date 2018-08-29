//
//  WisdomEffectView.swift
//  WisdomKeyboardKing
//
//  Created by jianfeng on 2018/8/25.
//  Copyright © 2018年 jianfeng. All rights reserved.
//

import UIKit

class WisdomEffectView: UIView {
    private let width: CGFloat=150
    private let height: CGFloat=26
    
    fileprivate static let shared = WisdomEffectView()
    private var clousres: ((Bool)->())?
    
    private lazy var verifyBtn: UIButton={
        let btn = UIButton()
        btn.setTitle("YES", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setImage(UIImage(named: "绿色对勾"), for: .normal)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(clickButton(btn:)), for: .touchUpInside)
        btn.imageEdgeInsets = UIEdgeInsetsMake(5, width-25, 5, 10)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -width, 0, 0)
        return btn
    }()
    
    private lazy var cancelBtn: UIButton={
        let btn = UIButton()
        btn.setTitle("NO", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setImage(UIImage(named: "红色打叉"), for: .normal)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(clickButton(btn:)), for: .touchUpInside)
        btn.imageEdgeInsets = UIEdgeInsetsMake(4, width-26, 4, 9)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -width, 0, 0)
        return btn
    }()
    
    private lazy var cancelEffectView : UIVisualEffectView = {
        let beffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let view = UIVisualEffectView(effect: beffect)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    private lazy var verifyEffectView : UIVisualEffectView = {
        let beffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let view = UIVisualEffectView(effect: beffect)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    fileprivate lazy var tapGesture: UITapGestureRecognizer={
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(tap:)))
        return tap
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(cancelEffectView)
        addSubview(verifyEffectView)
        addSubview(cancelBtn)
        addSubview(verifyBtn)
        
        cancelEffectView.snp.makeConstraints({ (make) in
            make.height.equalTo(height)
            make.width.equalTo(width)
            make.center.equalTo(self)
        })
        
        verifyEffectView.snp.makeConstraints({ (make) in
            make.height.equalTo(height)
            make.width.equalTo(width)
            make.centerX.equalTo(self)
            make.top.equalTo(cancelEffectView.snp.bottom).offset(10)
        })
        
        cancelBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(cancelEffectView)
        }
        
        verifyBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(verifyEffectView)
        }
    }
    
    @objc private func clickButton(btn: UIButton){
        if btn == verifyBtn{
            if clousres != nil{
                clousres!(true)
            }
        }else if btn == cancelBtn {
            if clousres != nil{
                clousres!(false)
            }
        }
        removeFromSuperview()
        clousres = nil
    }
    
    @objc private func tapGesture(tap: UITapGestureRecognizer){
        if clousres != nil{
            clousres!(false)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WisdomEffectView{
    
    class func showChoose(clousre: @escaping (Bool)->()) {
        let shared = WisdomEffectView.shared
        shared.clousres = clousre
        
        let window = UIApplication.shared.windows.last
        if !(window?.subviews.contains(shared))! {
            window?.addSubview(shared)
        }
        
        shared.snp.makeConstraints { (make) in
            make.edges.equalTo(window!)
        }
    }
}
