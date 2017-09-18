//
//  ReportViewController.swift
//  PPLittleNote
//
//  Created by suger on 2017/9/18.
//  Copyright © 2017年 diaoshihao. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var report = [String]()
    let tableview = UITableView.init(frame: UIScreen.main.bounds, style: .plain);

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
        return report.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReportCell = tableview.dequeueReusableCell(withIdentifier: "cell") as! ReportCell
        cell.selectionStyle = .none
        cell.textField.text = report[indexPath.section]
        return cell
    }
    
    func saveInfo() {
        
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

class ReportCell: UITableViewCell, UITextFieldDelegate {
    
    var textField = UITextField()
    
    var didChangeText: ((String) -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        textField.frame = self.contentView.bounds
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
