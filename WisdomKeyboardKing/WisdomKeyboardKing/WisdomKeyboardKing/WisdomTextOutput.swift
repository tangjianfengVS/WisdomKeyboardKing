//
//  WisdomTextOutput.swift
//  WisdomKeyboardKing
//
//  Created by jianfeng on 2018/8/17.
//  Copyright © 2018年 jianfeng. All rights reserved.
//

import UIKit

class WisdomTextOutput: NSObject {

    public static func textOutput(textString: String, type: WisdomTextOutputMode)->String{
        if type == .normal{
            return textString
        }
        
        if String(textString.last!) == " "{
            var string = textString
            string.removeLast()
            return string
        }
        
        let newStr = textString.replacingOccurrences(of: " ", with: "")
        if newStr.count == 0{
            return textString
        }
        var length: Int = 0
        var lengthSum: Int = 0
        switch type {
        case .PhoneNumber11_3:
            length = 3
            lengthSum = 11
        case .PhoneNumber11_4:
            length = 4
            lengthSum = 11
        case .BankcardNumber16_4:
            length = 4
            lengthSum = 16
        case .BankcardNumber19_4:
            length = 4
            lengthSum = 19
        default : break
        }
        
        if newStr.count > lengthSum {
            let group = lengthSum / length
            let index = textString.index(textString.startIndex, offsetBy:lengthSum+group)
            let result = textString[textString.startIndex..<index]
            return String(result)
            
        }else if newStr.count > length && newStr.count % length == 1{
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
        return textString
    }
}
