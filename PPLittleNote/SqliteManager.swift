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
            let sql = "CREATE TABLE IF NOT EXISTS person_info('from' TEXT, 'name' TEXT, 'sex' TEXT, 'age' TEXT, 'birthday' TEXT, 'idtype' TEXT, 'identity' TEXT, 'merriage' TEXT, 'profession' TEXT, 'income' TEXT, 'insurence' TEXT, 'report' TEXT, 'mobilephone' TEXT, 'telephone' TEXT, 'address' TEXT);"
            
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
        
        let sql = "INSERT INTO person_info (name, idtype, identity) VALUES (?,?,?)"
        if (db?.executeUpdate(sql, withArgumentsIn: [info.name, info.idtype, info.identity]))! {
            return true
        }
        
        db?.close()
        
        return false
    }
    
    func query(by:String, value: String) -> [UserInfo] {
        openDB()
        
        var resultArr = [UserInfo]()
        
        let sql = "SELECT * FROM person_info WHERE \(by) = ?"
        let result = db?.executeQuery(sql, withArgumentsIn: [value])
        if result == nil {
            return resultArr
        }
        while (result?.next())! {
            let info = UserInfo()
            info.name = (result?.string(forColumn: "name"))!
            
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
            info.name = (result?.string(forColumn: "name"))!
            
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
