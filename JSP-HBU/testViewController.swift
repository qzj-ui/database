//
//  ViewController.swift
//  JSP-HBU
//
//  Created by 齐子佳 on 2020/4/26.
//  Copyright © 2020 齐子佳. All rights reserved.
//

import UIKit

class testViewController: UIViewController {
    
    var database:Database!
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
        self.navigationController?.navigationItem.leftBarButtonItem?.customView?.isHidden = true
        database = Database()
        database.tableStudentCreate()
        database.tableCourseCreate()
        database.tableSCCreate()
        database.tableAdminCreate()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
           
       }


}

