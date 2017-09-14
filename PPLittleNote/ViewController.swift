//
//  ViewController.swift
//  PPLittleNote
//
//  Created by suger on 2017/9/12.
//  Copyright © 2017年 diaoshihao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let normalCell = "normal"
    let nameCell = "name"
    
    let tableview = UITableView.init(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
    
    var dataArr = Array<UserInfo>()
    let model = PersonModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "客户资源"
        
        let leftItem = UIBarButtonItem.init(title: "删除", style: .plain, target: self, action: #selector(removeUser))
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem.init(title: "添加", style: .plain, target: self, action: #selector(addUser))
        self.navigationItem.rightBarButtonItem = rightItem
        
        initSubview()
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableview.setEditing(false, animated: true)
    }
    
    func getData() {
        
        dataArr = model.getData();
        tableview.reloadData()
    }
    
    func initSubview() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: normalCell)
        
        self.view.addSubview(tableview)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "#"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: normalCell)
        cell?.selectionStyle = .none
        let info = dataArr[indexPath.row]
        cell?.textLabel?.text = info.name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = DetailViewController()
        VC.title = "客户详情"
        let info = dataArr[indexPath.row]
        VC.info = info
        VC.update = {
            self.getData()
        }
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let info = dataArr[indexPath.row]
        if model.deleteData(id: info.id) {
            dataArr.remove(at: indexPath.row)
            self.tableview.deleteRows(at: [indexPath], with: .automatic)
        }
        
        if dataArr.count == 0 {
            tableview.setEditing(false, animated: true)
        }
    }
    
    func removeUser(sender: UIBarButtonItem) {
        if dataArr.count == 0 {
            sender.title = "删除"
            tableview.setEditing(false, animated: true)
            return
        }
        
        tableview.setEditing(!tableview.isEditing, animated: true)
        
        if tableview.isEditing {
            sender.title = "完成"
        } else {
            sender.title = "删除"
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

