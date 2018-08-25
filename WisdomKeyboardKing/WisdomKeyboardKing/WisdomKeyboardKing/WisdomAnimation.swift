//
//  WisdomAnimation.swift
//  WisdomKeyboardKing
//
//  Created by jianfeng on 2018/8/19.
//  Copyright © 2018年 jianfeng. All rights reserved.
//

import UIKit

class WisdomAnimation: NSObject {
    fileprivate var clousres: ((Bool)->())?
    
    fileprivate lazy var showView: UIView={
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.addSubview(verifyBtn)
        view.addSubview(cancelBtn)
        
        verifyBtn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(view)
            make.left.equalTo(view).offset(UIScreen.main.bounds.width/2+20)
            make.width.height.equalTo(60)
        })
        cancelBtn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(view)
            make.right.equalTo(view).offset(-UIScreen.main.bounds.width/2-20)
            make.width.height.equalTo(60)
        })
        return view
    }()
    
    fileprivate lazy var verifyBtn: UIButton={
        let btn = UIButton()
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(clickButton(btn:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var cancelBtn: UIButton={
        let btn = UIButton()
        btn.addTarget(self, action: #selector(clickButton(btn:)), for: .touchUpInside)
        btn.backgroundColor = UIColor.blue
        return btn
    }()
    
    @objc private func clickButton(btn: UIButton){
        showView.removeFromSuperview()
        if btn == verifyBtn{
            if clousres != nil{
                clousres!(true)
            }
        }else if btn == cancelBtn {
            if clousres != nil{
                clousres!(false)
            }
        }
    }
}

extension WisdomAnimation{
    func merge(master: UIView, labList: [UILabel], editType: WisdomTextDidEditType) {
        
//        if editType == .negotiate_1 {
//
//            UIView.animate(withDuration: 0.2, animations: {
//                labList.last!.transform = CGAffineTransform(translationX: -master.bounds.width, y: 0)
//            }) { (_) in
//
//            }
//        }else if editType == .negotiate_2{
//
//
//        }
    }
    
    func reset(master: UIView, labList: [UILabel], editType: WisdomTextDidEditType) {
//        if editType == .negotiate_1 {
//
            UIView.animate(withDuration: 0.2, animations: {
                master.transform = CGAffineTransform.identity
                //labList.last?.transform = CGAffineTransform.identity
            }) { (_) in

            }
//        }else if editType == .negotiate_2{
//
//
//        }
    }
    
    //Delete the request
    func deleteShow(title: String, clousre: @escaping (Bool)->()){
        clousres = clousre
        let window = UIApplication.shared.windows.last
        if (window?.subviews.contains(showView))! {
            return
        }
        window?.addSubview(showView)
        
        showView.snp.makeConstraints { (make) in
            make.edges.equalTo(window!)
        }
    }
    
    func delete(master: UIView, labList: [UILabel], editType: WisdomTextDidEditType) ->
        (String,[UILabel],WisdomTextDidEditType){
            
//        master.removeFromSuperview()
//        if editType == .negotiate_1 {
//            for lab in labList{
//                lab.removeFromSuperview()
//            }
//            master.transform = CGAffineTransform.identity
//            return ((labList.first?.text)! + labList[1].text!, [], .fallow)
//        }else if editType == .negotiate_2{
//            
//            return ((labList.first?.text)! + labList[1].text!, labList, .negotiate_1)
//        }
        return ("", [],.fallow)
    }
    
    func exchange(master: UIView, labList: [UILabel], gestureView: UIView) -> Bool {
        let point = CGPoint(x: master.center.x + master.transform.tx - 15/2, y: master.center.y + master.transform.ty - 15/2)
        let rect = CGRect(origin: point, size: CGSize(width: 15, height: 15))
        
        for lab in labList {
            if rect.contains(lab.center){
                deleteShow(title: "互换?") { (res) in
                    if res{
                        let labRect = lab.frame
                        let masterRect = master.frame
                        lab.transform = CGAffineTransform.identity
                        master.transform = CGAffineTransform.identity
                        
                        lab.frame = labRect
                        master.frame = masterRect
                        lab.layoutIfNeeded()
                        master.layoutIfNeeded()
                        gestureView.layoutIfNeeded()
                    }else{
                        UIView.animate(withDuration: 0.2) {
                            lab.transform = CGAffineTransform.identity
                            master.transform = CGAffineTransform.identity
                        }
                    }
                }
                let masterOffsetX = master.center.x < lab.center.x ? master.frame.width: lab.frame.midX - master.frame.midX
                let labOffsetX = lab.center.x > master.center.x ? -master.frame.width:master.frame.width

                UIView.animate(withDuration: 0.2) {
                    lab.transform = CGAffineTransform(translationX: labOffsetX, y: 0)
                    master.transform = CGAffineTransform(translationX: masterOffsetX, y: 0)
                }
                return true
            }
        }
        return false
    }
}
