//
//  WisdomKeyboardConfig.swift
//  jianfeng
//
//  Created by jianfeng on 2018/8/6.
//  Copyright © 2018年 AllOverTheSkyStar. All rights reserved.
//  https://github.com/tangjianfengVS/WisdomKeyboardKing


import UIKit
/**
 * ------------------Introduction to the---------------------
 * Function 1: auto dodge UITextField, UITextView
 * Function 2: no need to write code correlation, pod integration can be used
 * Function 3: support switching input method to avoid
 * Function 4: support settable, control UITextField, UITextView's hiding distance from the keyboard
 * Function 5: enable the hiding of a large number of UITextField and UITextView on the same page
 
 * Function 6: UITextField, UITextView supports wisdomTask tasks：
                beginTasks: a callback when invoking a keyboard
               changeTasks: a callback when changing text content
                  endTasks: a callback when the keyboard is closed or the appropriate object is replaced
 
 * Function 7: Process input expiration time display
         test: 今天12点过期   明天过期    后天过期   2018年08月11日(已经过期显示)
 */


/**
 *  Default distance between keyboard and interactive object
 */
public let KeyboardBaseSpace: CGFloat = 10.0

/**
 *  UIView: The rootView of TransformView
 *  String: The current Content (title)
 *  CGRect: The frame of the UIScreen
 */
public typealias WisdomEventTask = ((UIView?,String?,CGRect)->())

/**
 *  The current state of the keyboard
 */
public enum WisdomKeyboardType {
    case sleep
    case awakeNormal
    case awakeTransform
}

/**
 *  The current keyboard root view moves object
    指定避让键盘的分类
              next:  指定上一级父视图避让键盘
              root:  UIViewController的View避让键盘
 */
public enum WisdomTransformTargetType {
    case next
    case root
}

/**
 *  The content output display styleOutput
    ---------数字号码分隔格式显示类型,对应如下样式----------
    PhoneNumber11_4:           1520 1218 189
    PhoneNumber11_3X4:         152 0121 8189
    BankcardNumber16_4:        1212 1212 1212 1212     (16位银行卡号)
    BankcardNumber19_4:        1212 1212 1212 1212 121 (19位银行卡号)
 */
public enum WisdomTextOutputMode {
    case normal
    case PhoneNumber11_4
    case PhoneNumber11_3X4
    case BankcardNumber16_4
    case BankcardNumber19_4
}

/**
 *  Time Raw data types for time processing
    时间处理的原始数据类型
 */
public enum WisdomInputTimeConvertType {
    case timestamp           //时间戳
    case input_joint         //"-"拼接
    case input_N_Y_R_joint   //"年，月，日"拼接
}
