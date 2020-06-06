//
//  StudentsLogViewController.swift
//  JSP-HBU
//
//  Created by 齐子佳 on 2020/4/29.
//  Copyright © 2020 齐子佳. All rights reserved.
//

import UIKit
import Foundation
import SCLAlertView

class StudentsLogInViewController: UIViewController {
    
    var database:Database!
    
    @IBOutlet weak var studentID: UITextField!
    @IBOutlet weak var pwd: UITextField!
    @IBAction func `return`(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func logIn(_ sender: Any) {
        if studentID.text!.isBlank || pwd.text!.isBlank
        {
            SCLAlertView().showError("学号或密码不能为空!",subTitle: "请检查输入!",closeButtonTitle: "好的")
        }
        else{
            let id:Int64 = Int64(studentID.text!)!
            if(self.database.searchTableStudent(id: id))
            {
                if(self.database.studentVertify(id: id, pwd: pwd.text!.md5()))
                {
                    let sb = UIStoryboard(name:"Main",bundle: Bundle.main)
                    let secondViewController = sb.instantiateViewController(withIdentifier: "student") as! studentsViewController
                    secondViewController.modalPresentationStyle = .fullScreen
                    secondViewController.studentID = id
                    self.present(secondViewController,animated: true,completion: nil)
                }
                else
                {
                    SCLAlertView().showError("密码错误",subTitle: "请重新输入!",closeButtonTitle: "好的")
                    pwd.text = ""
                }
            }
            else
            {
                SCLAlertView().showError("学号不存在!",subTitle: "请重新输入!",closeButtonTitle: "好的")
                studentID.text = ""
                pwd.text = ""
            }
        }
    }
    
    @IBAction func register(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(
             showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        let idTextField = alertView.addTextField("学号(11位)")
        idTextField.keyboardType = UIKeyboardType.numberPad
        let nameTextField = alertView.addTextField("姓名")
        let sexTextField = alertView.addTextField("性别")
        let ageTextField = alertView.addTextField("年龄")
        let departmentTextField = alertView.addTextField("所在系")
        ageTextField.keyboardType = UIKeyboardType.numberPad
        let pwdTextField = alertView.addTextField("密码(8-16位)")
        pwdTextField.keyboardType = UIKeyboardType.asciiCapable
        alertView.addButton("确定", action: {
            
            if idTextField.text!.isBlank || nameTextField.text!.isBlank || sexTextField.text!.isBlank || ageTextField.text!.isBlank || departmentTextField.text!.isBlank
            {
                SCLAlertView().showError("输入不可为空",subTitle: "请检查输入",closeButtonTitle: "好的")
            }
            else
            {
                if idTextField.text!.count != 11
                {
                    SCLAlertView().showError("学号输入有误",subTitle: "应为11位",closeButtonTitle: "好的")
                }else if pwdTextField.text!.count < 8 || pwdTextField.text!.count > 16
                {
                    SCLAlertView().showError("密码位数有误",subTitle: "应为8-16位",closeButtonTitle: "好的")
                }
                
                else
                {
                    let id:Int64 = Int64(idTextField.text!)!
                    let age:Int64 = Int64(ageTextField.text!)!
                    if(self.database.searchTableStudent(id: id))
                    {
                        SCLAlertView().showError("学号已存在",subTitle: "请重新输入",closeButtonTitle: "好的")
                    }
                    else
                    {
                        self.database.tableStudentInsertItem(id: id, password: pwdTextField.text!.md5(), name: nameTextField.text!, sex: sexTextField.text!, age: age, department: departmentTextField.text!)
                        SCLAlertView().showSuccess("注册成功！",closeButtonTitle: "好的")
                    }
                    
                }
            }
        })
            
        alertView.addButton("返回", action: {
            
        })
        alertView.showInfo("学生注册",subTitle:"请输入个人信息")
        
    }
    
    
    
    

    override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationItem.leftBarButtonItem?.customView?.isHidden = true
        
    self.hideKeyboardWhenTappedAround()
        database = Database()
    }

}




extension StudentsLogInViewController{
    //隐藏键盘
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StudentsLogInViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
