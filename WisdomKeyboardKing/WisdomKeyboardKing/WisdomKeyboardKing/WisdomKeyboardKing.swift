//
//  WisdomKeyboardKing.swift
//  jianfeng
//
//  Created by jianfeng on 2018/8/4.
//  Copyright © 2018年 AllOverTheSkyStar All rights reserved.
//

import UIKit

class NothingToSeeHere {
    static func harmlessFunction() {
        let _ = WisdomKeyboardKing.shared
    }
}

extension UIApplication {
    private static let runOnce: Void = {
        NothingToSeeHere.harmlessFunction()
    }()
    
    override open var next: UIResponder? {
        UIApplication.runOnce
        return super.next
    }
}

class WisdomKeyboardKing: NSObject{
    fileprivate var keyboardType: WisdomKeyboardType = .sleep
    fileprivate var transformView: UIView?
    fileprivate var responseView: UIView?
    
    fileprivate var transformSumY: CGFloat = 0
    fileprivate let animateTime: TimeInterval = 0.25
    fileprivate var keyboardFrame: CGRect = .zero
    
    fileprivate var formerTapGestures: [UITapGestureRecognizer]?
    fileprivate var transform: CGAffineTransform?
    
    fileprivate lazy var currentTapGesture: UITapGestureRecognizer={
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(tap:)))
        return tap
    }()
    
    fileprivate static let shared = WisdomKeyboardKing()
    
    fileprivate override init() {
        super.init()
        registerNotifications()
    }
    
    fileprivate func registerNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(noti:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(noti:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarOrientation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:[UIApplication sharedApplication]];
        
        registerTextFieldViewClass(textClass: UITextField.self, didBeginEditingNotificationName: Notification.Name.UITextFieldTextDidBeginEditing, didChangeNotificationName: Notification.Name.UITextFieldTextDidChange, didEndEditingNotificationName: Notification.Name.UITextFieldTextDidEndEditing)
        
        registerTextFieldViewClass(textClass: UITextView.self, didBeginEditingNotificationName: Notification.Name.UITextViewTextDidBeginEditing, didChangeNotificationName: Notification.Name.UITextViewTextDidChange, didEndEditingNotificationName: Notification.Name.UITextViewTextDidEndEditing)
    }
    
    /**
     *  Add customised Notification for third party customised TextField/TextView.
     */
    fileprivate func registerTextFieldViewClass(textClass: AnyClass,
                                            didBeginEditingNotificationName: Notification.Name,
                                            didChangeNotificationName: Notification.Name,
                                            didEndEditingNotificationName: Notification.Name){
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidBeginEditing(noti:)), name: didBeginEditingNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange(noti:)), name: didChangeNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidEndEditing(noti:)), name: didEndEditingNotificationName, object: nil)
    }
    
    @objc fileprivate func textViewDidBeginEditing(noti: Notification) {
        
        func nextView(view: UIView)->UIView?{
            var nextRes = view.next
            while(nextRes != nil){
                if let VC = nextRes as? UIViewController{
                    if formerTapGestures == nil{
                        formerTapGestures = VC.view.gestureRecognizers as? [UITapGestureRecognizer]
                    }
                    if transform == nil{
                        transform = VC.view.transform
                    }
                    VC.view.gestureRecognizers = nil
                    VC.view.addGestureRecognizer(currentTapGesture)
                    return VC.view
                }
                nextRes = nextRes?.next
            }
            return nil
        }
        
        func getSupView(view: UIView) {
            if let textField = view as? UITextField{
                switch textField.wisdomTransformTarget {
                case .next:
                    _ = nextView(view: textField)
                    transformView = textField.superview
                case .root:
                    transformView = nextView(view: textField)
                }
            }else if let textView = view as? UITextView{
                switch textView.wisdomTransformTarget {
                case .next:
                    _ = nextView(view: textView)
                    transformView = textView.superview
                case .root:
                    transformView = nextView(view: textView)
                }
            }
        }
        
        let window = UIApplication.shared.delegate?.window!
        if let textField = noti.object as? UITextField{
            responseView = textField
            getSupView(view: textField)
            transformView?.layoutIfNeeded()
            
            if textField.beginTask != nil{
                let rect = textField.convert(textField.bounds, to: window)
                textField.beginTask!(transformView,textField.text,rect)
            }
        }else if let textView = noti.object as? UITextView{
            responseView = textView
            getSupView(view: textView)
            transformView?.layoutIfNeeded()
   
            let rect = textView.convert(textView.bounds, to: window)
            if textView.beginTask != nil{
                textView.beginTask!(transformView,textView.text,rect)
            }
            
            let responseMaY = rect.maxY + textView.betweenKeyboardSpace
            transformAction(responseMaY: responseMaY)
        }
    }
    
    @objc fileprivate func textViewDidEndEditing(noti: Notification) {
        if let textField = noti.object as? UITextField{
            if textField.endTask != nil{
                let window = UIApplication.shared.delegate?.window!
                let rect = textField.convert(textField.bounds, to: window)
                textField.changeTask!(transformView,textField.text,rect)
            }
        }else if let textView = noti.object as? UITextView{
            if textView.endTask != nil{
                let window = UIApplication.shared.delegate?.window!
                let rect = textView.convert(textView.bounds, to: window)
                textView.endTask!(transformView,textView.text,rect)
            }
        }
    }
}

extension WisdomKeyboardKing {
    @objc fileprivate func textViewDidChange(noti: Notification) {
        if let textField = noti.object as? UITextField{
            self.textFieldContentMode(textField: textField)
            
            if textField.changeTask != nil{
                let window = UIApplication.shared.delegate?.window!
                let rect = textField.convert(textField.bounds, to: window)
                textField.changeTask!(transformView,textField.text,rect)
            }
        }else if let textView = noti.object as? UITextView{
            if textView.changeTask != nil{
                let window = UIApplication.shared.delegate?.window!
                let rect = textView.convert(textView.bounds, to: window)
                textView.changeTask!(transformView,textView.text,rect)
            }
        }
    }
    
    @objc fileprivate func keyBoardWillShow(noti: Notification){
        if let keyboardFrame = (noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardFrame = keyboardFrame
            
            if responseView != nil && transformView != nil{
                let window = UIApplication.shared.delegate?.window!
                let rect = responseView!.convert(responseView!.bounds, to: window)
                var responseMaY: CGFloat = 0
                
                if let textField = responseView as? UITextField{
                    responseMaY = rect.maxY + textField.betweenKeyboardSpace
                }else if let textView = responseView as? UITextView{
                    responseMaY = rect.maxY + textView.betweenKeyboardSpace
                }
                
                transformAction(responseMaY: responseMaY)
            }
        }
    }
    
    @objc fileprivate func keyBoardWillHide(noti: Notification){
        UIView.animate(withDuration: animateTime, animations: {
            self.transformView?.transform = self.transform != nil ? self.transform!:CGAffineTransform.identity
        }) { (_) in
            if let wisdom = self.responseView as? WisdomTextField{
                wisdom.logout()
            }
            self.transformView?.gestureRecognizers = self.formerTapGestures
            self.keyboardType = .sleep
            self.formerTapGestures = nil
            self.transformView = nil
            self.responseView = nil
            self.transform = nil
            self.transformSumY = 0
        }
    }
    
    /**
     *  Keyboard status interactive processing
     */
    fileprivate func transformAction(responseMaY: CGFloat){
        switch keyboardType {
        case .sleep:
            if responseMaY > keyboardFrame.origin.y{
                let transformOffsetY = keyboardFrame.origin.y - responseMaY
                transformSumY = -transformOffsetY
                keyboardType = .awakeTransform
                
                UIView.animate(withDuration: animateTime, animations: {
                    self.transformView!.transform = self.transformView!.transform.translatedBy(x: 0, y: transformOffsetY)
                })
            }else{
                keyboardType = .awakeNormal
            }
        case .awakeNormal:
            if responseMaY > keyboardFrame.origin.y{
                let transformOffsetY = keyboardFrame.origin.y - responseMaY
                transformSumY -= transformOffsetY
                keyboardType = .awakeTransform
                
                UIView.animate(withDuration: animateTime, animations: {
                    self.transformView!.transform = self.transformView!.transform.translatedBy(x: 0, y: transformOffsetY)
                })
            }
        case .awakeTransform:
            if responseMaY + transformSumY > keyboardFrame.origin.y{
                let transformOffsetY: CGFloat = keyboardFrame.origin.y - responseMaY
                transformSumY = transformSumY - transformOffsetY
                keyboardType = .awakeTransform
                
                UIView.animate(withDuration: animateTime, animations: {
                    self.transformView!.transform = self.transformView!.transform.translatedBy(x: 0, y: transformOffsetY)
                })
            }else if responseMaY > 0{
                transformSumY = 0
                keyboardType = .awakeNormal
                
                UIView.animate(withDuration: animateTime, animations: {
                    self.transformView?.transform = self.transform != nil ? self.transform!:CGAffineTransform.identity
                })
            }
        }
    }
    
    fileprivate func textFieldContentMode(textField: UITextField){
        if textField.text == nil {
            return
        }
        textField.text! = WisdomTextOutput.textOutput(textString: textField.text!, type: textField.textOutputMode!)
    }
    
    @objc fileprivate func tapGesture(tap: UITapGestureRecognizer) {
        transformView?.endEditing(true)
    }
}
