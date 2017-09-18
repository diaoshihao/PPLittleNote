//
//  DetailViewController.swift
//  PPLittleNote
//
//  Created by suger on 2017/9/13.
//  Copyright © 2017年 diaoshihao. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var update: (() -> Void)?
    
    let tableview = UITableView.init(frame: UIScreen.main.bounds, style: .plain);
    let titles = [["客户来源","备注姓名*","性别","年龄","出生日期","证件类型*","证件号码*","婚姻状况","职业","家庭年收入","有无车险"],["拜访记录"],["手机号码","固定电话","家庭住址"]]
    var info = UserInfo()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
                
        initSubview()
        let rightItem = UIBarButtonItem.init(title: "保存", style: .plain, target: self, action: #selector(saveInfo))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    func initSubview() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        tableview.register(CustomCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableview)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomCell = tableview.dequeueReusableCell(withIdentifier: "cell") as! CustomCell
        cell.selectionStyle = .none
        cell.imageView?.image = UIImage.init(named: "Group 5")
        cell.textLabel?.text = titles[indexPath.section][indexPath.row]
        
        if indexPath.section == 0 && (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 7 || indexPath.row == 10) || indexPath.section == 1 {
            cell.textField.isEnabled = false
        } else {
            cell.textField.isEnabled = true
        }
        setText(for: cell, at: indexPath)
        cell.didChangeText = {
            (text: String) -> Void in
            self.getText(from: text, at: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 2:
                showOptions(options: ["男", "女"], indexPath: indexPath)
            case 4:
                showOptions(options: [], indexPath: indexPath)
            case 5:
                showOptions(options: ["身份证", "护照", "港澳通行证"], indexPath: indexPath)
            case 7:
                showOptions(options: ["已婚", "未婚"], indexPath: indexPath)
            case 10:
                showOptions(options: ["有", "无"], indexPath: indexPath)
            default:
                break
            }
        }
        if indexPath.section == 1 {
            let VC = ReportViewController()
            VC.report = info.report
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func setText(for cell: CustomCell, at indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.textField.text = info.from
            case 1:
                cell.textField.text = info.name
            case 2:
                cell.textField.text = info.sex
            case 3:
                cell.textField.text = info.age
            case 4:
                cell.textField.text = info.birthday
            case 5:
                cell.textField.text = info.idtype
            case 6:
                cell.textField.text = info.identity
            case 7:
                cell.textField.text = info.merriage
            case 8:
                cell.textField.text = info.profession
            case 9:
                cell.textField.text = info.income
            case 10:
                cell.textField.text = info.insurence
            default:
                cell.textField.text = ""
            }
        } else {
            switch indexPath.row {
            case 0:
                cell.textField.text = info.mobilephone
            case 1:
                cell.textField.text = info.telephone
            case 2:
                cell.textField.text = info.address
            default:
                cell.textField.text = ""
            }
        }
    }
    
    func getText(from text: String, at indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                info.from = text
            case 1:
                info.name = text
            case 2:
                info.sex = text
            case 3:
                info.age = text
            case 4:
                info.birthday = text
            case 5:
                info.idtype = text
            case 6:
                info.identity = text
            case 7:
                info.merriage = text
            case 8:
                info.profession = text
            case 9:
                info.income = text
            case 10:
                info.insurence = text
            default: break
            }
        } else {
            switch indexPath.row {
            case 0:
                info.mobilephone = text
            case 1:
                info.telephone = text
            case 2:
                info.address = text
            default: break
            }
        }
    }
    
    func saveInfo() {
        //点击保存注销第一响应，让textfiled代理endEditing执行以更新数据
        self.view.endEditing(true)
        
        if info.name == "" || info.idtype == "" || info.identity == "" {
            showAlert(success: false)
            return
        }
        
        let userInfo = UserInfo(from: info.from, name: info.name, sex: info.sex, age: info.age, birthday: info.birthday, idType: info.idtype, identity: info.identity, merriage: info.merriage, profession: info.profession, income: info.income, insurence: info.insurence, report: info.report, mobilephone: info.mobilephone, telephone: info.telephone, address: info.address)
//        let model = PersonModel()
        
        let sqlMan = SqliteManager.shareManager
        
        showAlert(success: sqlMan.insert(info: userInfo))
//        showAlert(success: model.saveData(info: userInfo))
    }
    
    func showOptions(options: Array<String>, indexPath: IndexPath) {
        let pickerView = PickerView.init(with: options)
        pickerView.selectClosure = {
            (text: String) in
            let cell = self.tableview.cellForRow(at: indexPath) as! CustomCell
            cell.textField.text = text
            self.getText(from: text, at: indexPath)
        }
        pickerView.show()
    }
    
    func showAlert(success: Bool) {
        var message = "已更新数据"
        if !success {
            message = "保存失败"
        }
        
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (nil) in
            if success {
                if self.update != nil {
                    self.update!()
                }
                self.navigationController?.popViewController(animated: true)
            }
        }))
        self.present(alert, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


class CustomCell: UITableViewCell, UITextFieldDelegate {
    
    var textField = UITextField()
    
    var didChangeText: ((String) -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        textField.frame = CGRect(x: 150, y: 0, width: self.contentView.bounds.size.width-150, height: 44)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.delegate = self
        textField.returnKeyType = .done
        self.contentView.addSubview(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if didChangeText != nil {
            didChangeText!(textField.text!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
