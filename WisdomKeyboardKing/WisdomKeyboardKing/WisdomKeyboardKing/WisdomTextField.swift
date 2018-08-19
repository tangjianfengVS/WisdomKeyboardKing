//
//  WisdomTextField.swift
//  WisdomKeyboardKing
//
//  Created by jianfeng on 2018/8/18.
//  Copyright © 2018年 jianfeng. All rights reserved.
//

import UIKit

class WisdomTextField: UITextField {
    fileprivate var editType: WisdomTextDidEditType = .fallow
    fileprivate var beginMinX: CGFloat=0
    fileprivate var hasBeginMinX: Bool=false
    fileprivate var location: CGPoint = .zero
    
    fileprivate(set) var wisdomText: String=""
    fileprivate var labList: [UILabel]=[]
    fileprivate lazy var animation: WisdomAnimation = WisdomAnimation()
    
    fileprivate lazy var gestureView: UIView={
        let view = UIView()
        view.backgroundColor = UIColor.cyan
        return view
    }()
    
    fileprivate lazy var gestureLeftLab: UILabel={
        let lab = UILabel()
        lab.isUserInteractionEnabled = true
        lab.addGestureRecognizer(panGesture)
        return lab
    }()
    
    fileprivate lazy var gestureRightLab: UILabel={
        let lab = UILabel()
        return lab
    }()
    
    fileprivate lazy var tapGesture: UITapGestureRecognizer={
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(tap:)))
        return tap
    }()
    
    fileprivate lazy var panGesture: UIPanGestureRecognizer={
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture(pan:)))
        return pan
    }()

    fileprivate lazy var drawView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setFunc()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setFunc()
    }
    
    private func setFunc(){
        addSubview(gestureView)
        gestureView.addGestureRecognizer(tapGesture)

        gestureView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    @objc fileprivate func tapGesture(tap: UITapGestureRecognizer){
        if (editType == .fallow && editType != .drawing) ||
            (editType == .negotiate_1 || editType == .negotiate_2){
            editType = .imports
            beginMinX = 0
            hasBeginMinX = false
            text = wisdomText.count > 0 ? wisdomText:text
            drawView.removeFromSuperview()
            gestureLeftLab.removeFromSuperview()
            gestureRightLab.removeFromSuperview()
            
            for lab in labList{
                lab.removeFromSuperview()
            }
            becomeFirstResponder()
        }
    }
    
    func logout() {
        editType = .fallow
    }
}

extension WisdomTextField {
    @objc fileprivate func panGesture(pan: UITapGestureRecognizer){
        let point = pan.location(in: gestureView)
        switch pan.state {
        case .began:
            location = point
        case .changed:
            let offsetX = point.x - location.x
            let offsetY = point.y - location.y
            
            if -pan.view!.frame.midY >= pan.view!.bounds.height || pan.view!.frame.midY-8 >= pan.view!.bounds.height{
                animation.merge(master: pan.view!, labList: labList, editType: editType)
            }else{
                gestureLeftLab.transform = gestureLeftLab.transform.translatedBy(x: offsetX, y: offsetY)
            }
            location = point
        case .ended:
            if -pan.view!.frame.midY >= pan.view!.bounds.height || pan.view!.frame.midY-8 >= pan.view!.bounds.height{
                
                animation.deleteShow(title: "删除") {[weak self] (res) in
                    if res{
                        let resList = self?.animation.delete(master: pan.view!,labList: (self?.labList)!,
                                                             editType: (self?.editType)!)
                        self?.text = resList?.0
                        self?.labList = (resList?.1)!
                        self?.editType = (resList?.2)!
                    }else{
                        self?.animation.reset(master: pan.view!, labList: (self?.labList)!, editType: (self?.editType)!)
                    }
                }
            }else{
//                let exchange = animation.exchange(master: pan.view!, labList: labList, gestureView: gestureView)
//                if !exchange{
                    animation.reset(master: pan.view!, labList: labList, editType: editType)
//                }
            }
        default: break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if editType == .imports || text == nil || text?.count == 0{
            return
        }
        editType = .drawing
        let offsetX = (touches.first?.location(in: gestureView).x)!
        if !hasBeginMinX {
            beginMinX = offsetX > 5 ? offsetX:5
            hasBeginMinX = true
        }
        draw(endMaxX: offsetX)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if editType == .imports || text == nil || text?.count == 0{
            return
        }
        switch editType {
        case .fallow ,.drawing:
            creation()
        case .negotiate_1:
            print(gestureLeftLab.frame)
        case .negotiate_2:
            print("--negotiate_2")
        default:break
        }
        beginMinX = 0
        hasBeginMinX = false
        print("----Ended------")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if editType == .imports || text == nil || text?.count == 0{
            return
        }
        if editType == .drawing{
            creation()
        }
        print("----Cance------")
    }
    
    func draw(endMaxX: CGFloat) {
        if endMaxX - beginMinX < 2{
            return
        }
        
        if !gestureView.subviews.contains(drawView){
            gestureView.addSubview(drawView)
        }
        
        let rect = CGRect(x: beginMinX, y: 3, width: endMaxX-beginMinX, height: gestureView.bounds.height - 6)
        drawView.frame = rect
    }
    
    func creation(){
        let strList = division(rect: drawView.frame)
 
        var width = textSize(text: strList.first!, font: font!)
        let rect = CGRect(x: 7, y: 0, width: width, height: gestureView.bounds.height)
        let firstLab = UILabel(frame: rect)
        firstLab.font = font
        firstLab.text = strList.first
        firstLab.backgroundColor = UIColor.purple
        
        gestureView.addSubview(firstLab)
        labList.append(firstLab)
        
        if strList.count == 3 {
            if !gestureView.subviews.contains(gestureLeftLab) {
                gestureView.addSubview(gestureLeftLab)
            }

            width = textSize(text: strList[1], font: font!)
            gestureLeftLab.frame = CGRect(x: firstLab.frame.maxX, y: 2,
                                          width: width, height: gestureView.frame.height-4)
            
            let laterLab = UILabel()
            var laterWidth = textSize(text: strList[2], font: font!)
            laterWidth = laterWidth > gestureView.frame.width - gestureLeftLab.frame.maxX ? gestureView.frame.width - gestureLeftLab.frame.maxX:laterWidth
            
            laterLab.frame = CGRect(x: gestureLeftLab.frame.maxX, y: 0,
                                    width: laterWidth, height: gestureView.frame.height)
            
            gestureLeftLab.center.y = gestureView.center.y
            laterLab.center.y = gestureView.center.y
            
            gestureView.insertSubview(laterLab, belowSubview: gestureLeftLab)
            labList.append(laterLab)
            
            gestureLeftLab.text = strList[1]
            gestureLeftLab.font = font
            gestureLeftLab.backgroundColor = UIColor.red
            
            laterLab.text = strList[2]
            laterLab.font = font
            laterLab.backgroundColor = UIColor.green
        }else if strList.count == 4{
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            self.drawView.removeFromSuperview()
        })
    }
    
    func division(rect: CGRect)->[String]{
        wisdomText = text!
        text = ""
        let list = ["HHHH","8888888","gggmmmm"]
        if list.count == 3 {
            editType = .negotiate_1
        }else if list.count == 4 {
            editType = .negotiate_2
        }
        return list
    }
    
    func textSize(text : String , font : UIFont) -> CGFloat{
        let textMaxSize = CGSize(width: CGFloat(MAXFLOAT), height: 50)
        return text.boundingRect(with: textMaxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : font], context: nil).size.width
    }
}
