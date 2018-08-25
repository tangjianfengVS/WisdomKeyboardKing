//
//  WisdomTextOutput.swift
//  WisdomKeyboardKing
//
//  Created by jianfeng on 2018/8/17.
//  Copyright © 2018年 jianfeng. All rights reserved.
//

import UIKit

class WisdomTextOutput: NSObject {

    //WisdomTextOutputMode: Handles keyboard partitioning characters and bits
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
    
    //WisdomTextField: Record the current input character position and content
    static func recordWisdomChange(wisdomText: WisdomTextField){
        
        func textSize(text : String , font : UIFont) -> CGFloat{
            let textMaxSize = CGSize(width: CGFloat(MAXFLOAT), height: 50)
            return text.boundingRect(with: textMaxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : font], context: nil).size.width
        }
        
        if (wisdomText.text?.count)! < wisdomText.wisdomChars.count {
            wisdomText.wisdomChars.removeLast()
            
        }else if wisdomText.text?.count == 1 {
            let str = String((wisdomText.text?.last)!)
            let maxX = textSize(text: wisdomText.text!, font: wisdomText.font!)
            let chars = WisdomTextChars(minX: 0, maxX: maxX, text: str)
            wisdomText.wisdomChars.append(chars)
            
        }else if (wisdomText.text?.count)! > 1{
            let str = String(wisdomText.text!.last!)
            var newStr = wisdomText.text!
            newStr.removeLast()
            
            let minX = textSize(text: newStr, font: wisdomText.font!)
            let maxX = textSize(text: wisdomText.text!, font: wisdomText.font!)
            
            let chars = WisdomTextChars(minX: minX, maxX: maxX, text: str)
            wisdomText.wisdomChars.append(chars)
        }
    }
}
