//
//  WisdomTextOutput.swift
//  WisdomKeyboardKing
//
//  Created by jianfeng on 2018/8/17.
//  Copyright © 2018年 jianfeng. All rights reserved.
//

import UIKit

public class WisdomTextOutput: NSObject {

    //MARK: 处理数字类型分隔显示（WisdomTextOutputMode: Handles keyboard partitioning characters and bits）
    @objc public class func textOutput(textString: String, type: WisdomTextOutputMode)->String{
        if String(textString.last!) == " "{
            var string = textString
            string.removeLast()
            return string
        }
        
        var newStr = textString.replacingOccurrences(of: " ", with: "")
        if newStr.count == 0{
            return textString
        }
        let length: Int = 4
        var lengthSum: Int = 0
        switch type {
        case .PhoneNumber11_3X4, .PhoneNumber11_4:
            lengthSum = 11
        case .BankcardNumber16_4:
            lengthSum = 16
        case .BankcardNumber19_4:
            lengthSum = 19
        default : break
        }
        if newStr.count > lengthSum {
            let group = lengthSum / length
            let index = textString.index(textString.startIndex, offsetBy:lengthSum+group)
            let result = textString[textString.startIndex..<index]
            return String(result)
        }else{
            if type == .PhoneNumber11_3X4 {
                newStr.insert("0", at: newStr.startIndex)
            }
            
            if newStr.count > length && newStr.count % length == 1{
                let startIndex = textString.index(textString.endIndex, offsetBy:-2)
                let endIndex = textString.index(startIndex, offsetBy:1)
                let result = textString[startIndex..<endIndex]
                if result != " "{
                    let index = textString.index(before: textString.endIndex)
                    var newStr = textString
                    newStr.insert(" ", at: index)
                    return newStr
                }
            }
        }
        return textString
    }
    
    //MARK: 处理数字类型分隔显示,此方法用于直接赋值转换格式
    @objc public class func updateTextOutput(textString: String, type: WisdomTextOutputMode)->String{
        var newStr: String = textString.replacingOccurrences(of: " ", with: "")
        if newStr.count == 0{
            return textString
        }
        
        func updateStr(lengthSum: Int){
            if newStr.count > lengthSum {
                let startIndex = newStr.startIndex
                let endIndex = newStr.index(newStr.startIndex, offsetBy:lengthSum)
                newStr = String(newStr[startIndex..<endIndex])
            }
        }
        
        var resString: String = ""
        let length: Int = 4
        var lengthSum: Int = 0
        switch type {
        case .PhoneNumber11_3X4:
            lengthSum = 11
            updateStr(lengthSum: lengthSum)
            newStr.insert("0", at: newStr.startIndex)
        case .PhoneNumber11_4:
            lengthSum = 11
            updateStr(lengthSum: lengthSum)
        case .BankcardNumber16_4:
            lengthSum = 16
            updateStr(lengthSum: lengthSum)
        case .BankcardNumber19_4:
            lengthSum = 19
            updateStr(lengthSum: lengthSum)
        default : break
        }
        
        for i in 1...newStr.count {
            let sIndex = newStr.index(newStr.startIndex, offsetBy: i-1)
            let eIndex = newStr.index(newStr.startIndex, offsetBy: i)
            let str: String = String(newStr[sIndex..<eIndex])
            
            if i % length == 1 && i > 1 {
                resString.append(" ")
                resString.append(str)
            }else{
                resString.append(str)
            }
        }
        if type == .PhoneNumber11_3X4 {
            resString.removeFirst()
        }
        return resString
    }
    
    /**  Expiration time filter：  过期输出格式样式      [今天8点过期]   [明天过期]   [后天过期]
     *   timesText:               过期时间原始数据
     *   serverTimesText:         当前时间对比         (传nil默认与本地时间比对）
     *   type:                    输入处理的数据类型    (确认WisdomInputTimeConvertType)
     *   displayTypeList:         需要支持显示的过期时间类型数组，是WisdomExpiredTimeType类型数组
     *   expiredStr:              过期文字描述，传nill或者空，结尾默认拼接"过期"
     *   返回值:                   Bool: 是否过期     （true未过期，fales已经过期）
     *   @discussion:             -------因为OC不支持多数据返回值类型，所以此方法只支持Swift调用（OC版见下面）------
     */
    public class func expiredTimeOutput(timesText: String,
                                        serverTimesText: String?,
                                        type: WisdomInputTimeConvertType,
                                        displayTypeList: [WisdomExpiredTimeType.RawValue],
                                        expiredStr: String?) ->(Bool,String) {
        var expiredTitle = "过期"
        if expiredStr != nil &&  expiredStr!.count > 0{
            expiredTitle = expiredStr!
        }
        
        let resTime = WisdomTextOutput.getTargetAndCurrentTime(timesText: timesText, serverTimesText: serverTimesText, type: type)
        var targetTime = resTime.0
        var currentTime = resTime.1
        
        var timeList = WisdomTextOutput.getTime(time: &targetTime)
        let targetN = timeList.0
        let targetY = timeList.1
        let targetR = timeList.2
        let targetHM = timeList.3
        
        timeList = WisdomTextOutput.getTime(time: &currentTime)
        let currentN = timeList.0
        let currentY = timeList.1
        let currentR = timeList.2
        let currentHM = timeList.3
        
        let targetTimeSum = targetN + targetY + targetR
        let currentTimeSum = currentN + currentY + currentR
        let targetHMNew = targetHM.replacingOccurrences(of: ":", with: "", options: .literal, range: nil)
        let currentHMNew = currentHM.replacingOccurrences(of: ":", with: "", options: .literal, range: nil)
        
        if Int(currentTimeSum + currentHMNew)! < Int(targetTimeSum + targetHMNew)!{
            if Int(targetTimeSum)! - Int(currentTimeSum)! == 2{
                if displayTypeList.contains(WisdomExpiredTimeType.expiredAfterTomorrow_hour.hashValue){
                    let h = WisdomTextOutput.getDetailHour(targetHMNew: targetHMNew)
                    return (true,"后天"+h+expiredTitle)
                }
                return (true,"后天"+expiredTitle)
            }else if Int(targetTimeSum)! - Int(currentTimeSum)! == 1{
                if displayTypeList.contains(WisdomExpiredTimeType.expiredTomorrow_hour.hashValue){
                    let h = WisdomTextOutput.getDetailHour(targetHMNew: targetHMNew)
                    return (true,"明天"+h+expiredTitle)
                }
                return (true,"明天"+expiredTitle)
            }else if Int(targetTimeSum)! - Int(currentTimeSum)! == 0{
                if displayTypeList.contains(WisdomExpiredTimeType.expiredToday_hour.hashValue){
                    let h = WisdomTextOutput.getDetailHour(targetHMNew: targetHMNew)
                    return (true,"今天"+h+expiredTitle)
                }else if displayTypeList.contains(WisdomExpiredTimeType.expiredToday.hashValue){
                    return (true,"今天"+expiredTitle)
                }
            }
            return (false,targetN+"年"+targetY+"月"+targetR+"日")
        }
        return (false,targetN+"年"+targetY+"月"+targetR+"日")
    }
    
    /**  Expiration time filter： 过期输出格式样式      [今天8点过期]   [明天过期]   [后天过期]
     *   timesText:               过期时间原始数据
     *   serverTimesText:         当前时间对比         (传nil默认与本地时间比对）
     *   type:                    输入处理的数据类型    (确认WisdomInputTimeConvertType)
     *   displayTypeList:         需要支持显示的过期时间类型数组，是WisdomExpiredTimeType类型数组
     *   expiredStr:              过期文字描述，传nill或者空，结尾默认拼接"过期"
     *   返回值String:             需要显示过期描述，会有值返回
     *                            不需要显示过期描述，返回 ""
     *   @discussion:             ------因为OC不支持多数据返回值类型，所以OC处理过期数据调用此方法------
     */
    @objc public class func oc_ExpiredTimeOutput(timesText: String,
                                                 serverTimesText: String?,
                                                 type: WisdomInputTimeConvertType,
                                                 displayTypeList: [WisdomExpiredTimeType.RawValue],
                                                 expiredStr: String?) ->(String){
        let res = WisdomTextOutput.expiredTimeOutput(timesText: timesText,
                                                     serverTimesText: serverTimesText,
                                                     type: type,
                                                     displayTypeList: displayTypeList,
                                                     expiredStr: expiredStr)
        if res.0 {
            return res.1
        }
        return ""
    }
    
    /**  History time:    输出格式样式
     *                    2017年08月12日 21:30        （非同年）
     *                    09月12日 23:30              （同年）
     *                    昨天 20:30                  （昨天）
     *                    上午 10:30，下午 13:30        (当天）
     *   timesText:       历史时间原始数据
     *   serverTimestamp: 当前时间对比                 （传nil默认与本地时间比对）
     *   type:            输入处理的数据类型             (确认 WisdomInputTimeConvertType)
     */
    @objc public class func historyTimeOutput(timesText: String, serverTimesText: String?, type: WisdomInputTimeConvertType) -> String{
        let resTime = WisdomTextOutput.getTargetAndCurrentTime(timesText: timesText, serverTimesText: serverTimesText, type: type)
        var targetTime = resTime.0
        var currentTime = resTime.1

        var timeList = WisdomTextOutput.getTime(time: &targetTime)
        let targetN = timeList.0
        let targetY = timeList.1
        let targetR = timeList.2
        let targetHM = timeList.3

        timeList = WisdomTextOutput.getTime(time: &currentTime)
        let currentN = timeList.0
        let currentY = timeList.1
        let currentR = timeList.2

        let targetTimeSum: String = targetN + targetY + targetR
        let currentTimeSum: String = currentN + currentY + currentR
        let currentTimeSumInt: Int = Int(currentTimeSum)!
        let targetTimeSumInt: Int = Int(targetTimeSum)!
        let targetNInt: Int = Int(targetN)!
        let currentNInt: Int = Int(currentN)!

        if (currentTimeSumInt == targetTimeSumInt) {
            let targetHMNew = targetHM.replacingOccurrences(of: ":", with: "", options: .literal, range: nil)
            if Int(targetHMNew)! <= 1200{
                return "上午 "+targetHM
            }else{
                return "下午 "+targetHM
            }
        }else if (currentTimeSumInt - targetTimeSumInt == 1) {
            return "昨天 "+targetHM
        }else if (targetNInt == currentNInt) {
            return (targetY+"月"+targetR+"日 "+targetHM)
        }else{
            return (targetN+"年"+targetY+"月"+targetR+"日 "+targetHM)
        }
    }
}

extension WisdomTextOutput{
    //MARK: 时间戳转时间String，默认： .timestamp_10 类型
    @objc public class func getTimetampToStr(time: Int, format: DateFormatter, type: WisdomInputTimeConvertType)-> String{
        var timeInterval: TimeInterval = TimeInterval(time)
        if type == .timestamp_13 {
            timeInterval = TimeInterval(time)/1000.0
        }
        let date = Date(timeIntervalSince1970: timeInterval)
        return format.string(from: date).replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }

    fileprivate class func getTargetAndCurrentTime(timesText: String, serverTimesText: String?,
                                                   type: WisdomInputTimeConvertType) ->(String,String){
        let format = DateFormatter()
        var targetTime = timesText
        var currentTime = ""

        switch type {
        case .timestamp_10, .timestamp_13:
            format.dateFormat = "yyyyMMddHH:mm"

            if serverTimesText != nil && serverTimesText!.count > 0 {
                currentTime = serverTimesText!
            }else{
                let date = Date()
                var dateStamp: TimeInterval = date.timeIntervalSince1970
                if type == .timestamp_13{
                    dateStamp = date.timeIntervalSince1970*1000
                }
                let dateInt:Int = Int(dateStamp)
                currentTime = String(dateInt)
            }
            currentTime = WisdomTextOutput.getTimetampToStr(time: Int(currentTime)!, format: format, type: type)
            targetTime = WisdomTextOutput.getTimetampToStr(time: Int(targetTime)!, format: format, type: type)
        case .input_joint, .input_N_Y_R_joint:
            if type == .input_joint{
                format.dateFormat = "yyyy-MM-dd HH:mm"
            }else{
                format.dateFormat = "yyyy年MM月dd日 HH:mm"
            }

            if serverTimesText != nil && serverTimesText!.count > 0 {
                currentTime = serverTimesText!
            }else{
                let date = Date()
                currentTime = format.string(from: date)
            }
        }
        return (targetTime,currentTime)
    }
    
    fileprivate class func getTime(time: inout String) -> (String,String,String,String){
        time = time.replacingOccurrences(of: "年", with: "", options: .literal, range: nil)
        time = time.replacingOccurrences(of: "月", with: "", options: .literal, range: nil)
        time = time.replacingOccurrences(of: "日", with: "", options: .literal, range: nil)
        time = time.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        time = time.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
        
        var startIndex = time.startIndex
        var endIndex = time.index(time.startIndex, offsetBy: 4)
        let currentN: String = String(time[startIndex..<endIndex])
        
        startIndex = time.index(time.startIndex, offsetBy: 4)
        endIndex = time.index(time.startIndex, offsetBy: 6)
        let currentY: String = String(time[startIndex..<endIndex])
        
        startIndex = time.index(time.startIndex, offsetBy: 6)
        endIndex = time.index(time.startIndex, offsetBy: 8)
        let currentR: String = String(time[startIndex..<endIndex])
        
        startIndex = time.index(time.startIndex, offsetBy: 8)
        endIndex = time.index(time.startIndex, offsetBy: 13)
        let currentHM: String = String(time[startIndex..<endIndex])
        return (currentN,currentY,currentR,currentHM)
    }
    
    fileprivate class func getDetailHour(targetHMNew: String)-> String{
        let startIndex = targetHMNew.index(targetHMNew.startIndex, offsetBy: 0)
        let endIndex = targetHMNew.index(targetHMNew.startIndex, offsetBy: 2)
        
        var h: String = String(targetHMNew[startIndex..<endIndex])
        let intH: Int = Int(h)!
        h = (intH >= 10) ? h+"点":String(h.last!)+"点"
        return h
    }
}
