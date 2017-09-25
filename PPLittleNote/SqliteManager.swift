//
//  SqliteManager.swift
//  PPLittleNote
//
//  Created by suger on 2017/9/18.
//  Copyright © 2017年 diaoshihao. All rights reserved.
//

import UIKit

class SqliteManager: NSObject {
    static let shareSqliteManager = SqliteManager()
    
    class var shareManager:SqliteManager {
        return shareSqliteManager
    }
    
    var db: FMDatabase?
    
    func openDB() {
        let path = getFilePath()
        
        db = FMDatabase(path: path)
        
        if (db?.open())! {
            
            // 1.编写SQL语句
            let sql = "CREATE TABLE IF NOT EXISTS person_info('firstLetter' TEXT, 'origin' TEXT, 'name' TEXT, 'sex' TEXT, 'age' TEXT, 'birthday' TEXT, 'idtype' TEXT, 'identity' TEXT, 'merriage' TEXT, 'profession' TEXT, 'income' TEXT, 'insurence' TEXT, 'report' TEXT, 'mobilephone' TEXT, 'telephone' TEXT, 'address' TEXT);"
            
            // 2.执行SQL语句
            // 注意: 在FMDB中, 除了查询以外的操作都称之为更新
            if !(db?.executeUpdate(sql, withArgumentsIn: []))! {
                print("failed to crete")
            }
            
        } else {
            print("failed to open database")
        }
        
    }
    
    func insert(info: UserInfo) -> Bool {
        openDB()
        
        let sql = "INSERT INTO person_info (firstLetter, origin, name, sex, age, birthday, idtype, identity, merriage, profession, income, insurence, report, mobilephone, telephone, address) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        if (db?.executeUpdate(sql, withArgumentsIn: [info.firstLetter, info.from, info.name, info.sex, info.age, info.birthday, info.idtype, info.identity, info.merriage, info.profession, info.income, info.insurence, info.report, info.mobilephone, info.telephone, info.address]))! {
            return true
        }
        
        db?.close()
        
        return false
    }
    
    func update(info: UserInfo) -> Bool {
        openDB()
        
        let sql = "update person_info set firstLetter ='\(info.firstLetter)', origin = '\(info.from)', name = '\(info.name)', sex = '\(info.sex)', age = '\(info.age)', birthday = '\(info.birthday)', idtype = '\(info.idtype)', identity = '\(info.identity)', merriage = '\(info.merriage)', profession = '\(info.profession)' ,income = '\(info.income)', insurence = '\(info.insurence)', report = '\(info.report)', mobilephone = '\(info.mobilephone)', telephone = '\(info.telephone)', address = '\(info.address)' where identity = '\(info.identity)'"
        if (db?.executeUpdate(sql, withArgumentsIn: [info.firstLetter, info.from, info.name, info.sex, info.age, info.birthday, info.idtype, info.identity, info.merriage, info.profession, info.income, info.insurence, info.report, info.mobilephone, info.telephone, info.address]))! {
            return true
        }
        
        db?.close()
        
        return false
    }
    
    func query(by:String, value: String) -> [UserInfo] {
        openDB()
        
        var column = by
        if column == "from" {
            column = "origin"
        }
        
        var resultArr = [UserInfo]()
        
        let sql = "SELECT * FROM person_info WHERE \(by) = ?"
        let result = db?.executeQuery(sql, withArgumentsIn: [value])
        if result == nil {
            return resultArr
        }
        while (result?.next())! {
            let info = UserInfo()
            info.firstLetter = (result?.string(forColumn: "firstLetter"))!
            info.from = (result?.string(forColumn: "origin"))!
            info.name = (result?.string(forColumn: "name"))!
            info.sex = (result?.string(forColumn: "sex"))!
            info.age = (result?.string(forColumn: "age"))!
            info.birthday = (result?.string(forColumn: "birthday"))!
            info.idtype = (result?.string(forColumn: "idtype"))!
            info.identity = (result?.string(forColumn: "identity"))!
            info.merriage = (result?.string(forColumn: "merriage"))!
            info.profession = (result?.string(forColumn: "profession"))!
            info.income = (result?.string(forColumn: "income"))!
            info.insurence = (result?.string(forColumn: "insurence"))!
            info.report = (result?.string(forColumn: "report"))!
            info.mobilephone = (result?.string(forColumn: "mobilephone"))!
            info.telephone = (result?.string(forColumn: "telephone"))!
            info.address = (result?.string(forColumn: "address"))!
            
            resultArr.append(info)
        }
        
        db?.close()
        
        return resultArr
    }
    
    func queryAll() -> [UserInfo] {
        openDB()
        
        var resultArr = [UserInfo]()
        
        let sql = "SELECT * FROM person_info"
        let result = db?.executeQuery(sql, withArgumentsIn: [])
        if result == nil {
            return resultArr
        }
        while (result?.next())! {
            let info = UserInfo()
            info.firstLetter = (result?.string(forColumn: "firstLetter"))!
            info.from = (result?.string(forColumn: "origin"))!
            info.name = (result?.string(forColumn: "name"))!
            info.sex = (result?.string(forColumn: "sex"))!
            info.age = (result?.string(forColumn: "age"))!
            info.birthday = (result?.string(forColumn: "birthday"))!
            info.idtype = (result?.string(forColumn: "idtype"))!
            info.identity = (result?.string(forColumn: "identity"))!
            info.merriage = (result?.string(forColumn: "merriage"))!
            info.profession = (result?.string(forColumn: "profession"))!
            info.income = (result?.string(forColumn: "income"))!
            info.insurence = (result?.string(forColumn: "insurence"))!
            info.report = (result?.string(forColumn: "report"))!
            info.mobilephone = (result?.string(forColumn: "mobilephone"))!
            info.telephone = (result?.string(forColumn: "telephone"))!
            info.address = (result?.string(forColumn: "address"))!
            
            resultArr.append(info)
        }
        
        db?.close()
        
        return resultArr
    }
    
    func delete(identity: String) -> Bool {
        openDB()
        
        let sql = "DELETE FROM person_info WHERE identity = ?"
        let result = db?.executeUpdate(sql, withArgumentsIn: [identity])
  
        db?.close()
        
        return result!
    }
    
    /// get data.plist path
    func getFilePath() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = path.first!
        return documentDirectory.appending("/info_sqlite.db")
    }
}
