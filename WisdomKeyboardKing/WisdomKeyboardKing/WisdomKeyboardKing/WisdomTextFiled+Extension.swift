//
//  WisdomTextFiled+Extension.swift
//  jianfeng
//
//  Created by jianfeng on 2018/8/6.
//  Copyright © 2018年 AllOverTheSkyStar. All rights reserved.
//

import UIKit

fileprivate var WisdomTransformTargetKey_TextField = "WisdomTransformTargetKey_TextField";
fileprivate var WisdomBetweenKeyboardKey_TextField = "WisdomBetweenKeyboardKey_TextField";
fileprivate var WisdomBeginTaskKey_TextField = "WisdomBeginTaskKey_TextField";
fileprivate var WisdomChangeTaskKey_TextField = "WisdomChangeTaskKey_TextField";
fileprivate var WisdomEndTaskKey_TextField = "WisdomEndTaskKey_TextField";
fileprivate var WisdomTextOutputModeKey_TextField = "WisdomTextOutputModeKey_TextField";

@objc extension UITextField {
    public var wisdomTransformTarget: WisdomTransformTargetType{
        get{
            if let target = objc_getAssociatedObject(self, &WisdomTransformTargetKey_TextField) as? WisdomTransformTargetType{
                return target
            }
            return .root
        }
        set(newValue){
            objc_setAssociatedObject(self, &WisdomTransformTargetKey_TextField, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var betweenKeyboardSpace: CGFloat{
        get{
            if let space = objc_getAssociatedObject(self, &WisdomBetweenKeyboardKey_TextField) as? CGFloat{
                return space > 0 ? space:0
            }
            return KeyboardBaseSpace
        }
        set(newValue){
            objc_setAssociatedObject(self, &WisdomBetweenKeyboardKey_TextField, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private(set) var beginTask: WisdomEventTask?{
        get{
            if let block = objc_getAssociatedObject(self, &WisdomBeginTaskKey_TextField) as? WisdomEventTask{
                return block
            }
            return nil
        }
        set(newValue){
            objc_setAssociatedObject(self, &WisdomBeginTaskKey_TextField, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private(set) var changeTask: WisdomEventTask?{
        get{
            if let block = objc_getAssociatedObject(self, &WisdomChangeTaskKey_TextField) as? WisdomEventTask{
                return block
            }
            return nil
        }
        set(newValue){
            objc_setAssociatedObject(self, &WisdomChangeTaskKey_TextField, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private(set) var endTask: WisdomEventTask?{
        get{
            if let block = objc_getAssociatedObject(self, &WisdomEndTaskKey_TextField) as? WisdomEventTask{
                return block
            }
            return nil
        }
        set(newValue){
            objc_setAssociatedObject(self, &WisdomEndTaskKey_TextField, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var textOutputMode: WisdomTextOutputMode{
        get{
            if let mode = objc_getAssociatedObject(self, &WisdomTextOutputModeKey_TextField) as? WisdomTextOutputMode{
                return mode
            }
            return .normal
        }
        set(newValue){
            if newValue != WisdomTextOutputMode.normal {
                keyboardType = .numberPad
                
                if text != nil && text!.count > 0 {
                    text = WisdomTextOutput.updateTextOutput(textString: text!, type: newValue)
                }
            }
            objc_setAssociatedObject(self, &WisdomTextOutputModeKey_TextField, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /**  键盘任务回调
     *   beginTasks:   键盘将要唤起时回调任务
     *   changeTasks:  键盘变化文字内容时回调任务
     *   endTasks:     关闭键盘或者更换相应对象时回调任务
     */
    public func wisdomTask(beginTasks: @escaping WisdomEventTask, changeTasks: @escaping WisdomEventTask, endTasks: @escaping WisdomEventTask) {
        beginTask = beginTasks
        changeTask = beginTasks
        endTask = endTasks
    }
    
    /**  if setting WisdomTextOutputMode, get value set UITextField text only
     *   如果设置了WisdomTextOutputMode输出类型，用此方法获取‘Text’文本
     *   注：方法中去除了分隔符，数字类型文本结果内容也不需要分隔
     */
    public func outputText() -> String {
        if textOutputMode == .normal {
            return text != nil ? text!:""
        }
        return text!.replacingOccurrences(of: " ", with: "")
    }
}

