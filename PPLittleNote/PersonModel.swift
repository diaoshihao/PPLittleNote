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
        self.firstLetter = self.name.firstLetter()
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
    
//    required init?(coder aDecoder: NSCoder) {
//        self.firstLetter = aDecoder.decodeObject(forKey: "firstLetter") as! String
//        self.from = aDecoder.decodeObject(forKey: "from") as! String
//        self.name = aDecoder.decodeObject(forKey: "name") as! String
//        self.sex = aDecoder.decodeObject(forKey: "sex") as! String
//        self.age = aDecoder.decodeObject(forKey: "age") as! String
//        self.birthday = aDecoder.decodeObject(forKey: "birthday") as! String
//        self.idType = aDecoder.decodeObject(forKey: "idType") as! String
//        self.identity = aDecoder.decodeObject(forKey: "identity") as! String
//        self.merriage = aDecoder.decodeObject(forKey: "merriage") as! String
//        self.profession = aDecoder.decodeObject(forKey: "profession") as! String
//        self.income = aDecoder.decodeObject(forKey: "income") as! String
//        self.insurence = aDecoder.decodeObject(forKey: "insurence") as! String
//        self.mobilephone = aDecoder.decodeObject(forKey: "mobilephone") as! String
//        self.telephone = aDecoder.decodeObject(forKey: "telephone") as! String
//        self.address = aDecoder.decodeObject(forKey: "address") as! String
//        self.report = aDecoder.decodeObject(forKey: "report") as! Array
//    }
//    
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(firstLetter, forKey: "firstLetter")
//        aCoder.encode(from, forKey: "from")
//        aCoder.encode(name, forKey: "name")
//        aCoder.encode(sex, forKey: "sex")
//        aCoder.encode(age, forKey: "age")
//        aCoder.encode(birthday, forKey: "birthday")
//        aCoder.encode(idType, forKey: "idType")
//        aCoder.encode(id, forKey: "id")
//        aCoder.encode(merriage, forKey: "merriage")
//        aCoder.encode(profession, forKey: "profession")
//        aCoder.encode(income, forKey: "income")
//        aCoder.encode(insurence, forKey: "insurence")
//        aCoder.encode(mobilephone, forKey: "mobilephone")
//        aCoder.encode(telephone, forKey: "telephone")
//        aCoder.encode(address, forKey: "address")
//        aCoder.encode(report, forKey: "report")
//    }
}

class PersonModel: NSObject {
    
    let fileManager = FileManager()
    
    /// save userInfo with info
    /// if the info's id is exist,update, or add the info
    func saveData(info: UserInfo) -> Bool {
        
        let path = getFilePath()
        var userList = getData()
        
        let index = infoExists(id: info.identity)
        if index != -1 {
            userList.remove(at: index)
        }
        
        userList.append(info)
        
        //save to plist
        let data = NSMutableData()
        
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(userList, forKey: "userList")
        archiver.finishEncoding()
        
        if !data.write(toFile: path, atomically: true) {
            print("保存失败")
            return false
        }
        
        return true
    }
    
    /// return the index of item with id in userList
    /// if index is -1 means has not the item
    func infoExists(id: String) -> Int {
        let userList = getData()
        
        for item in userList {
            //the item of userList
            if item.identity == id {
                return userList.index(of: item)!
            }
        }
        return -1
    }
    
    /// return all userInfo list
    func getData() -> Array<UserInfo> {
        
        var userList = Array<UserInfo>()
        
        let path = getFilePath()
        
        //is fileManager exist
        if fileManager.fileExists(atPath: path) {
            let url = URL(fileURLWithPath: path)
            let data = try! Data(contentsOf: url)
            
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            userList = unarchiver.decodeObject(forKey: "userList") as! Array<UserInfo>
            unarchiver.finishDecoding()
        } else {
            print("没有数据文件")
        }
        
        return userList
    }
    
    /// delete info by given id of userInfo
    /// return false if the info is not exist
    func deleteData(id: String) -> Bool {
        let path = getFilePath()
        var userList = getData()
        
        let index = infoExists(id: id)
        if index != -1 {
            userList.remove(at: index)
        } else {
            return false
        }
        
        //save to plist
        let data = NSMutableData()
        
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(userList, forKey: "userList")
        archiver.finishEncoding()
        
        if !data.write(toFile: path, atomically: true) {
            print("保存失败")
            return false
        }
        
        return true
    }
    
    /// get documentDirectory path
    func getDocumentDirectory() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = path.first!
        return documentDirectory
    }
    
    /// get data.plist path
    func getFilePath() -> String {
        return getDocumentDirectory().appending("/userList.plist")
    }
}
