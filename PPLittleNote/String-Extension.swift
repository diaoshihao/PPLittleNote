//
//  String-Extension.swift
//  PPLittleNote
//
//  Created by suger on 2017/9/12.
//  Copyright © 2017年 diaoshihao. All rights reserved.
//

import Foundation

extension String {
    func converToPinyin() -> String {
        let string = NSMutableString(string: self)
        
        if CFStringTransform(string, nil, kCFStringTransformToLatin, false) == true {
            if CFStringTransform(string, nil, kCFStringTransformStripDiacritics, false) == true {
                return string as String
            }
        }
        return "#"
    }
    
    func firstLetter() -> String {
        let pinyin = self.converToPinyin()
        if pinyin == "" {
            return ""
        }
        let regular = "^[A-Z]$"
        
        let letter = pinyin.substring(to: pinyin.index(pinyin.startIndex, offsetBy: 1)).uppercased(with: nil)
        let letterPre = NSPredicate.init(format: "SELF MATCHES %@", regular)
        
        if letterPre.evaluate(with: letter) == true {
            return letter;
        }
        return "#"
    }
}
