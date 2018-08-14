//
//  WisdomTextView+Extension.swift
//  jianfeng
//
//  Created by jianfeng on 2018/8/6.
//  Copyright © 2018年 AllOverTheSkyStar. All rights reserved.
//

import UIKit

fileprivate var WisdomTransformTargetKey_TextView = "WisdomTransformTargetKey_TextField";
fileprivate var WisdomBetweenKeyboardKey_TextView = "WisdomBetweenKeyboardKey_TextField";
fileprivate var WisdomBeginTaskKey_TextView = "WisdomBeginTaskKey_TextField";
fileprivate var WisdomChangeTaskKey_TextView = "WisdomChangeTaskKey_TextField";
fileprivate var WisdomEndTaskKey_TextView = "WisdomEndTaskKey_TextField";

extension UITextView {
    var wisdomTransformTarget: WisdomTransformTargetType{
        get{
            if let target = objc_getAssociatedObject(self, &WisdomTransformTargetKey_TextView) as? WisdomTransformTargetType{
                return target
            }
            return .root
        }
        set(newValue){
            objc_setAssociatedObject(self, &WisdomTransformTargetKey_TextView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var betweenKeyboardSpace: CGFloat{
        get{
            if let space = objc_getAssociatedObject(self, &WisdomBetweenKeyboardKey_TextView) as? CGFloat{
                return space > 0 ? space:0
            }
            return KeyboardBaseSpace
        }
        set(newValue){
            objc_setAssociatedObject(self, &WisdomBetweenKeyboardKey_TextView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private(set) var beginTask: WisdomEventTask?{
        get{
            if let block = objc_getAssociatedObject(self, &WisdomBeginTaskKey_TextView) as? WisdomEventTask{
                return block
            }
            return nil
        }
        set(newValue){
            objc_setAssociatedObject(self, &WisdomBeginTaskKey_TextView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private(set) var changeTask: WisdomEventTask?{
        get{
            if let block = objc_getAssociatedObject(self, &WisdomChangeTaskKey_TextView) as? WisdomEventTask{
                return block
            }
            return nil
        }
        set(newValue){
            objc_setAssociatedObject(self, &WisdomChangeTaskKey_TextView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private(set) var endTask: WisdomEventTask?{
        get{
            if let block = objc_getAssociatedObject(self, &WisdomEndTaskKey_TextView) as? WisdomEventTask{
                return block
            }
            return nil
        }
        set(newValue){
            objc_setAssociatedObject(self, &WisdomEndTaskKey_TextView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func wisdomTask(beginTasks: @escaping WisdomEventTask, changeTasks: @escaping WisdomEventTask, endTasks: @escaping WisdomEventTask) {
        beginTask = beginTasks
        changeTask = beginTasks
        endTask = endTasks
    }
}
