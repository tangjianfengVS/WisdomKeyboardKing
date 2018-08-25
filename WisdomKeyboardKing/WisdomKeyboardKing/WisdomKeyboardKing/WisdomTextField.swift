//
//  WisdomTextField.swift
//  WisdomKeyboardKing
//
//  Created by jianfeng on 2018/8/18.
//  Copyright © 2018年 jianfeng. All rights reserved.
//

import UIKit

struct WisdomTextChars {
    var minX: CGFloat=0
    var maxX: CGFloat=0
    var text: String=""
}

struct WisdomTextRange {
    fileprivate(set) var range: NSRange!
    fileprivate(set) var rect: CGRect!
    let text: String!
    
    init(subText: String, texts: String, start: Int, end: Int,rects: CGRect) {
        text = texts
        rect = rects
        range = NSRange.init(location: start, length: (end - start) + 1)
    }
    
    mutating public func updateRect(rects: CGRect, ranges: NSRange) {
        rect = rects
        range = ranges
    }
}

class WisdomTextField: UITextField {
    fileprivate var editType: WisdomTextDidEditType = .fallow
    fileprivate var beginMinX: CGFloat=0
    fileprivate var hasBeginMinX: Bool=false
    fileprivate var location: CGPoint = .zero
    
    fileprivate var labList: [UILabel]=[]
    fileprivate lazy var animation: WisdomAnimation = WisdomAnimation()
    
    fileprivate var wisdomRanges: [WisdomTextRange]=[]
    var wisdomChars: [WisdomTextChars]=[]
    
    fileprivate lazy var gestureView: UIView={
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var gestureLeftLab: UILabel={
        let lab = UILabel()
        lab.isUserInteractionEnabled = true
        lab.layer.borderWidth = 0.8
        lab.layer.borderColor = UIColor.red.cgColor
        lab.addGestureRecognizer(panLeftGesture)
        return lab
    }()
    
    fileprivate lazy var gestureRightLab: UILabel={
        let lab = UILabel()
        lab.isUserInteractionEnabled = true
        lab.layer.borderWidth = 0.8
        lab.layer.borderColor = UIColor.green.cgColor
        lab.addGestureRecognizer(panRightGesture)
        return lab
    }()
    
    fileprivate lazy var tapGesture: UITapGestureRecognizer={
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(tap:)))
        return tap
    }()
    
    fileprivate lazy var panLeftGesture: UIPanGestureRecognizer={
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture(pan:)))
        return pan
    }()
    
    fileprivate lazy var panRightGesture: UIPanGestureRecognizer={
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture(pan:)))
        return pan
    }()

    fileprivate lazy var drawView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.gray
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
        if gestureView.subviews.contains(drawView) {
            return
        }
        
        if (editType == .fallow ) {
            becomeFirstResponder()
        }else if (editType == .drawing_negotiate_1 || editType == .drawing_negotiate_2 ) {
            
            animation.deleteShow(title: "删除") {[weak self] (res) in
                if res{
                    self?.cancel()
                    self?.text = self?.text
                    self?.editType = .imports
                    self?.wisdomRanges = []
                    self?.gestureLeftLab.removeFromSuperview()
                    self?.gestureRightLab.removeFromSuperview()
                    self?.becomeFirstResponder()
                }
            }
        }
    }
    
    func logout() {
        editType = .fallow
    }
    
    fileprivate func setting(){
        switch wisdomRanges.count {
        case 0:
            editType = .fallow
        case 1:
            editType = .drawing_negotiate_1
        case 2:
            editType = .drawing_negotiate_2
        default:
            break
        }
    }
    
    fileprivate func cancel(){
        beginMinX = 0
        hasBeginMinX = false
        drawView.frame = CGRect.zero
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
            
            pan.view!.transform = pan.view!.transform.translatedBy(x: offsetX, y: offsetY)
            //if -pan.view!.frame.midY >= pan.view!.bounds.height || pan.view!.frame.midY-8 >= pan.view!.bounds.height{
            //animation.merge(master: pan.view!, labList: labList, editType: editType)
            //}else{}
            location = point
        case .ended:
            if -pan.view!.frame.midY >= pan.view!.bounds.height || pan.view!.frame.midY-8 >= pan.view!.bounds.height{
                
                animation.deleteShow(title: "删除") {[weak self] (res) in
                    if res{
                        self?.removeStr(panView: pan.view!)
                    }else{
                        self?.animation.reset(master: pan.view!, labList: (self?.labList)!, editType: (self?.editType)!)
                    }
                }
            }else{
                //let exchange = animation.exchange(master: pan.view!, labList: labList, gestureView: gestureView)
                //if !exchange{
                animation.reset(master: pan.view!, labList: labList, editType: editType)
                //}
            }
        default: break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if editType == .imports || text?.count == 0 || editType == .drawing_negotiate_2 {
            return
        }
        let point = touches.first?.location(in: gestureView)
        
        if gestureView.subviews.contains(gestureLeftLab) {
            let rect = CGRect(x: gestureLeftLab.frame.minX, y: 0, width: gestureLeftLab.frame.width, height: gestureView.frame.height)
            if rect.contains(point!){
                return
            }
        }
        
        let offsetX = point!.x
        if !hasBeginMinX {
            beginMinX = offsetX > 5 ? offsetX:5
            hasBeginMinX = true
        }
        draw(endMaxX: offsetX)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if editType == .imports || text?.count == 0 || editType == .drawing_negotiate_2 {
            return
        }
        let point = touches.first?.location(in: gestureView)
        
        if gestureView.subviews.contains(gestureLeftLab) {
            let rect = CGRect(x: gestureLeftLab.frame.minX, y: 0, width: gestureLeftLab.frame.width, height: gestureView.frame.height)
            if rect.contains(point!){
                return
            }
        }
        
        if !creatTextRang(rect: drawView.frame) {
            return
        }
        division()
        creation()
        cancel()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if editType == .imports || text?.count == 0 || editType == .drawing_negotiate_2 {
            return
        }
        let point = touches.first?.location(in: gestureView)
        
        if gestureView.subviews.contains(gestureLeftLab) {
            let rect = CGRect(x: gestureLeftLab.frame.minX, y: 0, width: gestureLeftLab.frame.width, height: gestureView.frame.height)
            if rect.contains(point!){
                return
            }
        }
        
        if !creatTextRang(rect: drawView.frame) {
            return
        }
        division()
        creation()
        cancel()
    }
}

extension WisdomTextField{
    //动态建视图
    fileprivate func draw(endMaxX: CGFloat) {
        if endMaxX - beginMinX < 2{
            return
        }
        
        if !gestureView.subviews.contains(drawView){
            gestureView.addSubview(drawView)
        }
        
        let rect = CGRect(x: beginMinX, y: 3, width: endMaxX-beginMinX, height: gestureView.bounds.height - 6)
        drawView.frame = rect
    }
    
    //分割字符
    fileprivate func creatTextRang(rect: CGRect) -> Bool{
        let minX: CGFloat = rect.minX-7
        let maxX: CGFloat = rect.maxX-7
        var start: Int = 0
        var end: Int = 0
        var string = ""
        
        for i in 0..<wisdomChars.count {
            if wisdomChars[i].minX >= minX-3 && wisdomChars[i].maxX <= maxX+3 {
                if string.count == 0{
                    start = i
                }
                end = i
                string.append(wisdomChars[i].text)
            }
        }
        if string.count > 0 {
            let width = textSize(text: string, font: font!)
            let rect = CGRect(x: wisdomChars[start].minX+7, y: 3, width: width, height: gestureView.frame.height-6)
            let textRange = WisdomTextRange(subText: text!, texts: string, start: start, end: end,rects: rect)
            wisdomRanges.append(textRange)
            setting()
            return true
        }else{
            setting()
            cancel()
            return false
        }
    }
    
    //设置富文本
    fileprivate func division(){
        let attrStr = NSMutableAttributedString.init(string: text!)
        
        for range in wisdomRanges {
            attrStr.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear,
                                   NSAttributedStringKey.font: font!], range: range.range)
        }
        attributedText = attrStr
    }
    
    //创建Label
    fileprivate func creation(){
        for i in 0..<wisdomRanges.count {
            if i == 0{
                if !gestureView.subviews.contains(gestureLeftLab) {
                    gestureView.addSubview(gestureLeftLab)
                }
                gestureLeftLab.frame = wisdomRanges[i].rect
                gestureLeftLab.text = wisdomRanges[i].text
                gestureLeftLab.font = font
            }else if i == 1{
                if !gestureView.subviews.contains(gestureRightLab) {
                    gestureView.addSubview(gestureRightLab)
                }
                gestureRightLab.frame = wisdomRanges[i].rect
                gestureRightLab.text = wisdomRanges[i].text
                gestureRightLab.font = font
            }
        }
        drawView.removeFromSuperview()
    }
    
    fileprivate func textSize(text : String , font : UIFont) -> CGFloat{
        let textMaxSize = CGSize(width: CGFloat(MAXFLOAT), height: 50)
        return text.boundingRect(with: textMaxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : font], context: nil).size.width
    }
}

extension WisdomTextField{
    //删除
    func removeStr(panView: UIView) {
        var index: Int=0
        if panView == gestureLeftLab {
            index = 0
        }else if panView == gestureRightLab {
            index = 1
        }
        
        let start = wisdomRanges[index].range.location
        let end = wisdomRanges[index].range.length
        let widthX = wisdomRanges[index].rect.width
        let range = text!.index(text!.startIndex, offsetBy: start) ..< text!.index(text!.startIndex, offsetBy: start + end)
        var newWisdomChars: [WisdomTextChars] = []
        
        for i in 0..<wisdomChars.count {
            if i < start{
                newWisdomChars.append(wisdomChars[i])
                
            }else if i >= end + start {
                let minX = wisdomChars[i].minX - wisdomRanges[index].rect.size.width
                let maxX = wisdomChars[i].maxX - wisdomRanges[index].rect.size.width
                let textChars = WisdomTextChars(minX: minX, maxX: maxX, text: wisdomChars[i].text)
                newWisdomChars.append(textChars)
            }
        }

        text!.removeSubrange(range)
        wisdomRanges.remove(at: index)
        wisdomChars = newWisdomChars
        gestureLeftLab.removeFromSuperview()
        gestureRightLab.removeFromSuperview()
        
        if wisdomRanges.count == 1 && index == 0 {
            let rect = CGRect(x: wisdomRanges.first!.rect.minX - widthX, y: wisdomRanges.first!.rect.minY,
                              width: wisdomRanges.first!.rect.width, height: wisdomRanges.first!.rect.height)
            let range = NSRange.init(location: wisdomRanges[0].range.location - end,
                                     length: wisdomRanges[0].range.length)
            wisdomRanges[0].updateRect(rects: rect, ranges: range)
        }
        setting()
        division()
        creation()
    }
}


























//        let list = ["HHHH","8888888","gggmmmm"]
//        if list.count == 3 {
//            editType = .negotiate_1
//        }else if list.count == 4 {
//            editType = .negotiate_2
//        }

//        var width = textSize(text: strList.first!, font: font!)
//        let rect = CGRect(x: 7, y: 0, width: width, height: gestureView.bounds.height)
//        let firstLab = UILabel(frame: rect)
//        firstLab.font = font
//        firstLab.text = strList.first
//        firstLab.backgroundColor = UIColor.purple
//        gestureView.addSubview(firstLab)
//        labList.append(firstLab)

//        if strList.count == 3 {
//            if !gestureView.subviews.contains(gestureLeftLab) {
//                gestureView.addSubview(gestureLeftLab)
//            }

//            width = textSize(text: strList[1], font: font!)
//            gestureLeftLab.frame = CGRect(x: firstLab.frame.maxX, y: 2,
//                                          width: width, height: gestureView.frame.height-4)
//
//            let laterLab = UILabel()
//            var laterWidth = textSize(text: strList[2], font: font!)
//            laterWidth = laterWidth > gestureView.frame.width - gestureLeftLab.frame.maxX ? gestureView.frame.width - gestureLeftLab.frame.maxX:laterWidth

//            laterLab.frame = CGRect(x: gestureLeftLab.frame.maxX, y: 0,
//                                    width: laterWidth, height: gestureView.frame.height)

//            gestureLeftLab.center.y = gestureView.center.y
//            laterLab.center.y = gestureView.center.y

//            gestureView.insertSubview(laterLab, belowSubview: gestureLeftLab)
//            labList.append(laterLab)

//            gestureLeftLab.text = strList[1]
//            gestureLeftLab.font = font
//            gestureLeftLab.backgroundColor = UIColor.red

//            laterLab.text = strList[2]
//            laterLab.font = font
//            laterLab.backgroundColor = UIColor.green
//        }else if strList.count == 4{
//
//        }
