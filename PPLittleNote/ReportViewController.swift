//
//  ReportViewController.swift
//  PPLittleNote
//
//  Created by suger on 2017/9/18.
//  Copyright © 2017年 diaoshihao. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataArr = [String]()
    
    var adding = false
    
    var DidAddReport: (([String]) -> Void)?
    
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
        tableview.tableFooterView = addButton()
        tableview.register(ReportCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableview)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if adding {
            return dataArr.count + 1
        }
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReportCell = tableview.dequeueReusableCell(withIdentifier: "cell") as! ReportCell
        cell.selectionStyle = .none
        
        //when adding, the last cell setting will beyond dataArr
        if indexPath.section != dataArr.count {
            cell.textView.text = dataArr[indexPath.section]
        }
        
        return cell
    }
    
    func addButton() -> UIView {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44)
        button.setTitle("添加记录", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(addReport), for: .touchUpInside)
        
        let seperator = UIView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 1))
        seperator.backgroundColor = UIColor.lightGray
        button.addSubview(seperator)
        
        return button
    }
    
    func saveInfo() {
        if !adding {
            return
        }
        adding = false
        self.view.endEditing(true)
        
        let cell: ReportCell = tableview.cellForRow(at: IndexPath(row: 0, section: dataArr.count)) as! ReportCell
        let newReport = cell.textView.text
        if newReport != nil {
            
            dataArr.append(newReport!)
            if DidAddReport != nil {
                DidAddReport!(dataArr)
            }
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    func addReport() {
        adding = true
        tableview.reloadData()
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

class ReportCell: UITableViewCell, UITextViewDelegate {
    
    var textView = UITextView()
    
    var didChangeText: ((String) -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        textView.frame = self.contentView.bounds
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.delegate = self
        self.contentView.addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
