//
//  WisdomKeyboardConfig.swift
//  jianfeng
//
//  Created by jianfeng on 2018/8/6.
//  Copyright © 2018年 AllOverTheSkyStar. All rights reserved.

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
 */
public enum WisdomTransformTargetType {
    case next
    case root
}

/**
 *  The content output display styleOutput
 */
public enum WisdomTextOutputMode {
    case normal
    case PhoneNumber11_3    // The longest is 11, one serving 3
    case PhoneNumber11_4    // The longest is 11, one serving 4
    case BankcardNumber16_4 // The longest is 16, one portion for 4
    case BankcardNumber19_4 // The longest is 19, one portion for 4
}

/**
 *  WisdomTextField： Edit keyboard status
 */
public enum WisdomTextDidEditType {
    case fallow              //leisure
    case imports             //input
    case drawing_negotiate_1 //One finished painting
    case drawing_negotiate_2 //Two finished paintings
    case drag_negotiate_1    //Current drag editor for the first
    case drag_negotiate_2    //Current drag editor for the second
}

