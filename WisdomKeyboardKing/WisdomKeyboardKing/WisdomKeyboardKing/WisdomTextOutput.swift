//
//  WisdomTextOutput.swift
//  WisdomKeyboardKing
//
//  Created by jianfeng on 2018/8/17.
//  Copyright © 2018年 jianfeng. All rights reserved.
//

import UIKit

class WisdomTextOutput: NSObject {

    //MARK: 处理数字类型分隔显示（WisdomTextOutputMode: Handles keyboard partitioning characters and bits）
    public static func textOutput(textString: String, type: WisdomTextOutputMode)->String{
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
    
    /**  Expiration time filter： 过期输出格式样式
                                  [今天8点过期]   [明天过期]   [后天过期]
     *   timesText:               过期时间原始数据
     *   serverTimesText:         当前时间对比         (不传默认与本地时间比对）
     *   type:                    输入处理的数据类型    (确认 WisdomInputTimeConvertType)
     */
    static func expiredTimeOutput(timesText: String, serverTimesText: String?, type: WisdomInputTimeConvertType) ->(Bool,String) {
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
                return (true,"后天过期")
            }else if Int(targetTimeSum)! - Int(currentTimeSum)! == 1{
                return (true,"明天过期")
            }else if Int(targetTimeSum)! - Int(currentTimeSum)! == 0{
                let startIndex = targetHMNew.index(targetHMNew.startIndex, offsetBy: 0)
                let endIndex = targetHMNew.index(targetHMNew.startIndex, offsetBy: 2)
                var h = String(targetHMNew[startIndex..<endIndex])
                h = (Int(h)! >= 10) ? h+"点":String(h.last!)+"点"
                return (true,"今天"+h+"过期")
            }
            return (true,targetN+"年"+targetY+"月"+targetR+"日")
        }
        return (false,targetN+"年"+targetY+"月"+targetR+"日")
    }
    
    /**  History time:    输出格式样式
     *                    2017年08月12日 21:30        （非同年）
                          09月12日 23:30              （同年）
                          昨天 20:30                  （昨天）
                          上午 10:30，下午 13:30        (当天）
     *   timesText:       历史时间原始数据
     *   serverTimestamp: 当前时间对比                 （不传默认与本地时间比对）
     *   type:            输入处理的数据类型             (确认 WisdomInputTimeConvertType)
     */
    static func historyTimeOutput(timesText: String, serverTimesText: String?, type: WisdomInputTimeConvertType) -> String{
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

        let targetTimeSum = targetN + targetY + targetR
        let currentTimeSum = currentN + currentY + currentR

        if (Int(currentTimeSum)! == Int(targetTimeSum)!) {
            let targetHMNew = targetHM.replacingOccurrences(of: ":", with: "", options: .literal, range: nil)
            if Int(targetHMNew)! <= 1200{
                return "上午 "+targetHM
            }else{
                return "下午 "+targetHM
            }
        }else if (Int(currentTimeSum)! - Int(targetTimeSum)! == 1) {
            return "昨天 "+targetHM
        }else if (Int(targetN)! == Int(currentN)!) {
            return (targetY+"月"+targetR+"日 "+targetHM)
        }else{
            return (targetN+"年"+targetY+"月"+targetR+"日 "+targetHM)
        }
    }
}

extension WisdomTextOutput{
    //MARK: 时间戳转时间String
    class func getTimetampToStr(time: Int ,format: DateFormatter)-> String{
        let timeInterval: TimeInterval = TimeInterval(time)
        let date = Date(timeIntervalSince1970: timeInterval)
        return format.string(from: date).replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    
    class fileprivate func getTargetAndCurrentTime(timesText: String, serverTimesText: String?,
                                                   type: WisdomInputTimeConvertType) ->(String,String){
        let format = DateFormatter()
        var targetTime = timesText
        var currentTime = ""
        
        switch type {
        case .timestamp:
            format.dateFormat = "yyyyMMddHH:mm"
            
            if serverTimesText != nil && serverTimesText!.count > 0 {
                currentTime = serverTimesText!
            }else{
                let date = Date()
                let dateStamp: TimeInterval = date.timeIntervalSince1970
                let dateInt:Int = Int(dateStamp)
                currentTime = String(dateInt)
            }
            currentTime = WisdomTextOutput.getTimetampToStr(time: Int(currentTime)!, format: format)
            targetTime = WisdomTextOutput.getTimetampToStr(time: Int(targetTime)!, format: format)
        case .input_joint, .input_N_Y_R_joint:
            format.dateFormat = (type == .input_joint) ? "yyyy-MM-dd HH:mm":"yyyy年MM月dd日 HH:mm"
            
            if serverTimesText != nil && serverTimesText!.count > 0 {
                currentTime = serverTimesText!
            }else{
                let date = Date()
                currentTime = format.string(from: date)
            }
        }
        return (targetTime,currentTime)
    }
    
    class fileprivate func getTime(time: inout String) -> (String,String,String,String){
        time = time.replacingOccurrences(of: "年", with: "", options: .literal, range: nil)
        time = time.replacingOccurrences(of: "月", with: "", options: .literal, range: nil)
        time = time.replacingOccurrences(of: "日", with: "", options: .literal, range: nil)
        time = time.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        time = time.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
        
        var startIndex = time.startIndex
        var endIndex = time.index(time.startIndex, offsetBy: 4)
        let currentN = String(time[startIndex..<endIndex])
        
        startIndex = time.index(time.startIndex, offsetBy: 4)
        endIndex = time.index(time.startIndex, offsetBy: 6)
        let currentY = String(time[startIndex..<endIndex])
        
        startIndex = time.index(time.startIndex, offsetBy: 6)
        endIndex = time.index(time.startIndex, offsetBy: 8)
        let currentR = String(time[startIndex..<endIndex])
        
        startIndex = time.index(time.startIndex, offsetBy: 8)
        endIndex = time.index(time.startIndex, offsetBy: 13)
        let currentHM = String(time[startIndex..<endIndex])
        return (currentN,currentY,currentR,currentHM)
    }
}
