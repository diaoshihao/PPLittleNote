//
//  ViewController.swift
//  PPLittleNote
//
//  Created by suger on 2017/9/12.
//  Copyright © 2017年 diaoshihao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let normalCell = "normal"
    let nameCell = "name"
    
    let tableview = UITableView.init(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
    
    var allArr = [UserInfo]()
    
    var dataArr = Array<[UserInfo]>()
    var letterArr = [String]()
    
    
    var isSearching = false
    var searchArr = Array<UserInfo>()
    
    let sqlMan = SqliteManager.shareManager
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "客户资源"
        
        let leftItem = UIBarButtonItem.init(title: "刷新", style: .plain, target: self, action: #selector(output))
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem.init(title: "添加", style: .plain, target: self, action: #selector(addUser))
        self.navigationItem.rightBarButtonItem = rightItem
        
        initSubview()
        
        getData()
    }
    
    func getData() {
        
        allArr = sqlMan.queryAll().sorted(by: { (info1, info2) -> Bool in
            return info1.firstLetter < info2.firstLetter
        })
        
        var personDict = [String:[UserInfo]]()
        
        //group
        for info in allArr {
            if personDict[info.firstLetter] != nil {
                personDict[info.firstLetter]?.append(info)
            } else {
                let newGroup = [info]
                personDict[info.firstLetter] = newGroup
            }
        }
        
        letterArr = personDict.keys.sorted(by: <)
        if letterArr.contains("#") {
            letterArr.remove(at: letterArr.index(of: "#")!)
            letterArr.append("#")
        }
        
        dataArr.removeAll()
        for firstLetter in letterArr {
            dataArr.append(personDict[firstLetter]!)
        }
        
        tableview.reloadData()
    }
    
    func initSubview() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableHeaderView = headerView()
        tableview.tableFooterView = UIView()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: normalCell)
        
        self.view.addSubview(tableview)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return 1
        }
        return letterArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearching {
            return searchArr.count
        }
        
        let group = dataArr[section]
        return group.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSearching {
            return 0
        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return letterArr[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: normalCell)
        cell?.selectionStyle = .none
        let info = isSearching ? searchArr[indexPath.row] : dataArr[indexPath.section][indexPath.row]
        cell?.textLabel?.text = info.name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = DetailViewController()
        VC.title = "客户详情"
        let info = isSearching ? searchArr[indexPath.row] : dataArr[indexPath.section][indexPath.row]
        VC.info = info
        VC.update = {
            self.getData()
        }
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return isSearching ? .none : .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let alert = UIAlertController.init(title: "提示", message: "是否删除", preferredStyle: .alert)
        let delete = UIAlertAction.init(title: "删除", style: .default) { (delete) in
            self.removeUser(indexPath: indexPath)
        }
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeUser(indexPath: IndexPath) {
        let info = isSearching ? searchArr[indexPath.row] : dataArr[indexPath.section][indexPath.row]
        if sqlMan.delete(identity: info.identity) {
            getData()
            tableview.reloadData()
        } else {
            print("failed to delete")
        }
    }
    
    func addUser() {
        let VC = DetailViewController()
        VC.title = "添加客户"
        VC.update = {
            self.getData()
        }
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func output() {
        getData()
    }
    
    
    func headerView() -> UIView {
        let searchBar = UISearchBar.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "取消"
        return searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        searchArr.removeAll()
        for item in allArr {
            if item.name.contains(searchText) || item.name.converToPinyin().contains(searchText) {
                searchArr.append(item)
            }
        }
        tableview.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        isSearching = true
        tableview.reloadData()
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        isSearching = false
        searchArr.removeAll()
        tableview.reloadData()
        searchBar.showsCancelButton = false
        return true
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

