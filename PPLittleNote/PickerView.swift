//
//  PickerView.swift
//  PPLittleNote
//
//  Created by suger on 2017/9/15.
//  Copyright © 2017年 diaoshihao. All rights reserved.
//

import UIKit

class PickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    let picker = UIPickerView()
    
    var optionsArr = Array<String>()
    
    var selectedStr: String
    
    var selectClosure: ((String) -> Void)?
    
    required init(with options: Array<String>) {
        selectedStr = ""
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        optionsArr = options
        let y = UIScreen.main.bounds.size.height-200
        let width = UIScreen.main.bounds.size.width
        
        if optionsArr.count == 0 {
            let datePicker = UIDatePicker(frame: CGRect(x: 0, y: y, width: width, height: 200))
            datePicker.backgroundColor = UIColor.white
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(pickDate(picker:)), for: .valueChanged)
            self.addSubview(datePicker)
            
            let formatter = DateFormatter()
            //日期样式
            formatter.dateFormat = "yyyy-MM-dd"
            selectedStr = formatter.string(from: datePicker.date)
        } else {
            selectedStr = options.first!
            
            picker.frame = CGRect.init(x: 0, y: y, width: width, height: 200)
            picker.backgroundColor = UIColor.white
            picker.delegate = self
            picker.dataSource = self
            self.addSubview(picker)
        }
  
        let view = UIView.init(frame: CGRect.init(x: 0, y: y-45, width: width, height: 44))
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: width-60, y: 0, width: 60, height: 44)
        button.setTitle("确定", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        view.addSubview(button)
        
        let cancel = UIButton(type: .custom)
        cancel.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(UIColor.black, for: .normal)
        cancel.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        view.addSubview(cancel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func show() {
        UIApplication.shared.keyWindow?.endEditing(true)
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    func pickDate(picker: UIDatePicker) {
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd"
        selectedStr = formatter.string(from: picker.date)
    }
    
    func sureAction() {
        if self.selectClosure != nil {
            self.selectClosure!(selectedStr)
        }
        self.removeFromSuperview()
    }
    
    func cancelAction() {
        self.removeFromSuperview()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return optionsArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return optionsArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedStr = optionsArr[row]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
