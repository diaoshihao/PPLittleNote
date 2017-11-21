//
//  PersonModel.swift
//  PPLittleNote
//
//  Created by suger on 2017/9/12.
//  Copyright © 2017年 diaoshihao. All rights reserved.
//

import UIKit

class UserInfo: NSObject {
    
    var firstLetter = ""
    
    var from = ""
    var name = ""
    var sex = ""
    var age = ""
    var birthday = ""
    var idtype = ""
    var identity = ""
    var merriage = ""
    var profession = ""
    var income = ""
    var insurence = ""
    var mobilephone = ""
    var telephone = ""
    var address = ""
    var report = ""
    
    
    override init() {
        
    }
    
    init(from: String, name: String, sex: String, age: String, birthday: String, idType: String, identity: String, merriage: String, profession: String, income: String, insurence: String, report: String, mobilephone: String, telephone: String, address: String) {
        super.init()
        self.firstLetter = name.firstLetter()
        self.from = from
        self.name = name
        self.sex = sex
        self.age = age
        self.birthday = birthday
        self.idtype = idType
        self.identity = identity
        self.merriage = merriage
        self.profession = profession
        self.income = income
        self.insurence = insurence
        self.mobilephone = mobilephone
        self.telephone = telephone
        self.address = address
        self.report = report
    }
    
    override var description: String {
        return self.firstLetter+self.name
    }
}
