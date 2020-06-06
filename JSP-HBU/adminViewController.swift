//
//  adminViewController.swift
//  JSP-HBU
//
//  Created by 齐子佳 on 2020/5/13.
//  Copyright © 2020 齐子佳. All rights reserved.
//

import UIKit
import SCLAlertView
import Foundation
import SQLite

class adminViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    
    var database:Database!
    
    var adminID:Int64?

    @IBAction func quit(_ sender: Any) {
        let sb = UIStoryboard(name:"Main",bundle: Bundle.main)
        let secondViewController = sb.instantiateViewController(withIdentifier: "First")
        secondViewController.modalPresentationStyle = .fullScreen
        self.present(secondViewController,animated: true,completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Database()
        let admin = database.readTableAdmin(id: adminID!)
        userName.text = "欢迎\(admin!.name)老师！"
        print(admin!.id)
        print(admin!.name)
        print(admin!.department)
        
    }
}
