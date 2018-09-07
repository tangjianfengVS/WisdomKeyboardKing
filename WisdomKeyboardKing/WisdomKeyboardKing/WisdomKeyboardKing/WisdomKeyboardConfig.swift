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
