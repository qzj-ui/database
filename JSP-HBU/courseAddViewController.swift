//
//  courseAddViewController.swift
//  JSP-HBU
//
//  Created by 齐子佳 on 2020/5/18.
//  Copyright © 2020 齐子佳. All rights reserved.
//

import UIKit
import SCLAlertView

class courseAddViewController: UIViewController {
    
    var database:Database!
    
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var credit: UITextField!
    @IBOutlet weak var num: UITextField!
    
    
    @IBAction func clean(_ sender: Any) {
        id.text = ""
        name.text = ""
        credit.text = ""
        num.text = ""
    }
    
    @IBAction func add(_ sender: Any) {
        if id.text!.isBlank || name.text!.isBlank || credit.text!.isBlank || num.text!.isBlank{
            SCLAlertView().showError("课程信息不能为空！",subTitle: "请检查输入！",closeButtonTitle: "好的")
        }else{
            let c:Int64 = Int64(credit.text!)!
            let n:Int64 = Int64(num.text!)!
            if id.text!.count != 5{
                SCLAlertView().showError("课程号输入有误",subTitle: "应为5位",closeButtonTitle: "好的")
            }
            else if c<1 || c>10{
                SCLAlertView().showError("学分输入有误！",subTitle: "应为1～10的整数",closeButtonTitle: "重新输入")
            }
            else if n<1 || n>10{
                SCLAlertView().showError("课序号输入有误！",subTitle: "应为1～10的整数",closeButtonTitle: "重新输入")
            }
            else{
                let _id = Int64(id.text!)!
                if database.tableCourseInsertItem(id: _id, name: name.text!, credit: c, pno: n){
                    SCLAlertView().showSuccess("课程插入成功",subTitle: "课程号为\(id.text!)",closeButtonTitle: "好的")
                    
                }
                else{
                    SCLAlertView().showError("课程插入失败",subTitle:"请检查输入",closeButtonTitle: "好的")
                }

            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database = Database()
        
    }
    

}
