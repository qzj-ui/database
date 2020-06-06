//
//  studentsViewController.swift
//  JSP-HBU
//
//  Created by 齐子佳 on 2020/5/13.
//  Copyright © 2020 齐子佳. All rights reserved.
//

import UIKit
import SCLAlertView
import Foundation

class studentsViewController: UIViewController {
    
    @IBAction func quit(_ sender: Any) {
        let sb = UIStoryboard(name:"Main",bundle: Bundle.main)
        let secondViewController = sb.instantiateViewController(withIdentifier: "First")
        secondViewController.modalPresentationStyle = .fullScreen
        self.present(secondViewController,animated: true,completion: nil)
    }
    
    var database:Database!
    
    @IBOutlet weak var userName: UILabel!
    
    var studentID:Int64?

    override func viewDidLoad() {
        super.viewDidLoad()
        database = Database()
        let student = database.readTableStudent(id: studentID!)
        userName.text = "欢迎\(student!.name)同学！"
        print(student!.name)
        print(student!.age)
        print(student!.department)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "studentsTabBar"
        {
            let detailVC = segue.destination as! StuTabBarViewController
            detailVC.stuID = studentID
        }
        if segue.identifier == "grades"{
            let detailVC = segue.destination as! GradesViewController
            detailVC.stuID = studentID
        }
    }
    
}
