//
//  adminLogViewController.swift
//  JSP-HBU
//
//  Created by 齐子佳 on 2020/4/29.
//  Copyright © 2020 齐子佳. All rights reserved.
//

import UIKit
import SCLAlertView
import Foundation

class adminLogInViewController: UIViewController {
    
    var database: Database!
    
    @IBOutlet weak var adminID: UITextField!
    @IBOutlet weak var pwd: UITextField!
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func logIn(_ sender: Any) {
        if adminID.text!.isBlank || pwd.text!.isBlank{
            SCLAlertView().showError("工号或密码不能为空!",subTitle: "请检查输入!",closeButtonTitle: "好的")
        }
        else{
            let id:Int64 = Int64(adminID.text!)!
            if(self.database.searchTableAdmin(id: id))
            {
                if(self.database.AdminVertify(id: id, pwd: pwd.text!.md5())){
                    let sb = UIStoryboard(name:"Main",bundle: Bundle.main)
                    let secondViewController = sb.instantiateViewController(withIdentifier: "admin") as! adminViewController
                    secondViewController.modalPresentationStyle = .fullScreen
                    secondViewController.adminID = id
                    self.present(secondViewController,animated: true,completion: nil)
                }
                else{
                    SCLAlertView().showError("密码错误",subTitle: "请重新输入!",closeButtonTitle: "好的")
                    pwd.text = ""
                }
            }
            else{
                SCLAlertView().showError("工号不存在!",subTitle: "请重新输入!",closeButtonTitle: "好的")
                adminID.text = ""
                pwd.text = ""
            }
        }
    }
    
    @IBAction func register(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(
             showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        let idTextField = alertView.addTextField("工号(5位)")
        idTextField.keyboardType = UIKeyboardType.numberPad
        let nameTextField = alertView.addTextField("姓名")
        let departmentTextField = alertView.addTextField("所在系")
        let pwdTextField = alertView.addTextField("密码(8-16位)")
        pwdTextField.keyboardType = UIKeyboardType.asciiCapable
        alertView.addButton("确定", action: {
            
            if idTextField.text!.isBlank || nameTextField.text!.isBlank ||  departmentTextField.text!.isBlank
            {
                SCLAlertView().showError("输入不可为空",subTitle: "请检查输入",closeButtonTitle: "好的")
            }
            else
            {
                if idTextField.text!.count != 5
                {
                    SCLAlertView().showError("工号输入有误",subTitle: "应为5位",closeButtonTitle: "好的")
                }else if pwdTextField.text!.count < 8 || pwdTextField.text!.count > 16
                {
                    SCLAlertView().showError("密码位数有误",subTitle: "应为8-16位",closeButtonTitle: "好的")
                }
                
                else
                {
                    let id:Int64 = Int64(idTextField.text!)!
                    if(self.database.searchTableStudent(id: id))
                    {
                        SCLAlertView().showError("工号已存在",subTitle: "请重新输入",closeButtonTitle: "好的")
                    }
                    else
                    {
                        self.database.tableAdminInsertItem(id: id, password: pwdTextField.text!.md5(), name: nameTextField.text!,  department: departmentTextField.text!)
                        SCLAlertView().showSuccess("注册成功！",closeButtonTitle: "好的")
                    }
                    
                }
            }
        })
            
        alertView.addButton("返回", action: {
            
        })
        alertView.showInfo("管理员注册",subTitle:"请输入个人信息")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database = Database()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationItem.leftBarButtonItem?.customView?.isHidden = true
        self.hideKeyboardWhenTappedAround()
    }


}
extension adminLogInViewController{
    //隐藏键盘
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(adminLogInViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
