//
//  StuTabBarViewController.swift
//  JSP-HBU
//
//  Created by 齐子佳 on 2020/5/24.
//  Copyright © 2020 齐子佳. All rights reserved.
//

import UIKit

class StuTabBarViewController: UITabBarController {
    var stuID:Int64?
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    override func viewDidLoad() {
        print(stuID!)
        let viewControllers = self.viewControllers!
        
        let v1 = viewControllers[0] as! selectCourseViewController
        let v2 = viewControllers[1] as! quitCourseViewController
        let v3 = viewControllers[2] as! myCourseViewController
        v1.stuID = stuID
        v2.stuID = stuID
        v3.stuID = stuID        
    }
    override func viewDidAppear(_ animated: Bool) {
//        print(self.tabBarController?.viewControllers)
    }
    
}
