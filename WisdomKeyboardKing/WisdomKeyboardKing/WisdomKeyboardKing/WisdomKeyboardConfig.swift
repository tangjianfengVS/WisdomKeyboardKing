//
//  WisdomKeyboardConfig.swift
//  jianfeng
//
//  Created by jianfeng on 2018/8/6.
//  Copyright © 2018年 AllOverTheSkyStar. All rights reserved.
//  https://github.com/tangjianfengVS/WisdomKeyboardKing
//  简介请看 README.md

import UIKit

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
 *  指定避让键盘的分类
 *  next:  指定上一级父视图避让键盘
 *  root:  UIViewController的View避让键盘
 *  window:  添加在Window上的父视图移动对象
 */
@objc public enum WisdomTransformTargetType: NSInteger {
    case next=0
    case root=1
    case window=2
}

/**
 *  The content output display styleOutput
 *   ---------数字号码分隔格式显示类型,对应如下样式----------
 *  PhoneNumber11_4:           1520 1218 189
 *  PhoneNumber11_3X4:         152 0121 8189
 *  BankcardNumber16_4:        1212 1212 1212 1212     (16位银行卡号)
 *  BankcardNumber19_4:        1212 1212 1212 1212 121 (19位银行卡号)
 */
@objc public enum WisdomTextOutputMode: NSInteger {
    case normal=0
    case PhoneNumber11_4=1
    case PhoneNumber11_3X4=2
    case BankcardNumber16_4=3
    case BankcardNumber19_4=4
}

/**
 *  Time Raw data types for time processing
 *  时间处理的原始数据类型
 */
@objc public enum WisdomInputTimeFormatType: NSInteger {
    case timestamp_10=0        //10位时间戳 String
    case timestamp_13=1        //13位时间戳 String
    case input_joint=2         //"-"拼接 String
    case input_N_Y_R_joint=3   //"年，月，日"拼接 String
}

/**
 *  The expiration time type that needs to be supported for display
 *  需要支持显示的过期时间类型
 *  使用规则：  1.默认值: expiredTomorrow， expiredAfterTomorrow
 *            2.精确度越高，级别越高:  expiredToday_hour > expiredToday
 *                                 expiredTomorrow_hour > expiredTomorrow
 *                                 expiredAfterTomorrow_hour > expiredAfterTomorrow
 *            3.设置了高级别，会过滤低级别样式，低级别样式不再显示
 *            4.高级别,低级别同时显示，只安装高级别样式显示
 *            5.expiredToday 和 expiredToday_hour都不设置，“今天过期”不显示
 */
@objc public enum WisdomExpiredTimeType: NSInteger {
    case expiredToday=0                 //今天过期
    case expiredToday_hour=1            //今天8点过期
    case expiredTomorrow=2              //明天过期
    case expiredTomorrow_hour=3         //明天8点过期
    case expiredAfterTomorrow=4         //后天过期
    case expiredAfterTomorrow_hour=5    //后天8点过期
}
