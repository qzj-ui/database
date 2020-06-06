//
//  gradeViewController.swift
//  JSP-HBU
//
//  Created by 齐子佳 on 2020/5/18.
//  Copyright © 2020 齐子佳. All rights reserved.
//

import UIKit
import SCLAlertView
//表格排序协议
protocol UICollectionGridViewSortDelegate4: class {
    func sort(colIndex: Int, asc: Bool, rows: [[Any]]) -> [[Any]]
}

class gradeViewController: UIViewController,UICollectionGridViewSortDelegate4 {
    @IBOutlet weak var please: UILabel!
    func sort(colIndex: Int, asc: Bool, rows: [[Any]]) -> [[Any]] {
        let sortedRows = rows.sorted { (firstRow: [Any], secondRow: [Any])
            -> Bool in
            let firstRowValue = firstRow[colIndex] as! String
            let secondRowValue = secondRow[colIndex] as! String
            if colIndex == 1 {
                //首例、姓名使用字典排序法
                if asc {
                    return firstRowValue < secondRowValue
                }
                return firstRowValue > secondRowValue
            } else if colIndex == 2 || colIndex == 3 || colIndex == 0{
                //中间两列使用数字排序
                if asc {
                    return Int(firstRowValue)! < Int(secondRowValue)!
                }
                return Int(firstRowValue)! > Int(secondRowValue)!
            }
            return true
        }
        return sortedRows
    }
    
    
    var database:Database!
    var gridViewController: UICollectionGridViewController4!

    override func viewDidLoad() {
        super.viewDidLoad()
        database = Database()
        update()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        update()
    }
    func update() -> Void{
        let scs = database.queryTableSC()
        if scs.count == 0{
            please.isHidden = false
        }
        else{
            gridViewController = UICollectionGridViewController4()
            //gridViewController.stuID = stuID
            gridViewController.sortDelegate = self
            gridViewController.setColumns(columns: ["学生姓名","学生学号", "课程名","课程号", "课程学分","当前成绩"])
            for sc in scs{
                let student = database.readTableStudent(id: sc.sno)
                let course = database.readTableCourse(id: sc.cno)
                print(sc.grade)
                if sc.grade == -1{
                    gridViewController.addRow(row: [student!.name,student!.id,course!.name,course!.id,course!.credit,"成绩未录入"])
                }else{
                    gridViewController.addRow(row: [student!.name,student!.id,course!.name,course!.id,course!.credit,sc.grade])
                }
                
//                let id = String(course.id)
//                gridViewController.addRow(row:[ id,course.name,course.credit,course.pno])
            }
            view.addSubview(gridViewController.view)
        }
    }
    
    
}
//多列表格组件（通过CollectionView实现）
class UICollectionGridViewController4: UICollectionViewController {
    
    var stuID:Int64?
    
    var database:Database!
    //表头数据
    var cols: [String]! = []
    //行数据
    var rows: [[Any]]! = []
     
    //排序代理
    weak var sortDelegate: UICollectionGridViewSortDelegate4?
     
    //选中的表格列（-1表示没有选中的）
    private var selectedColIdx = -1
    //列排序顺序
    private var asc = true
     
    init() {
        //初始化表格布局
        let layout = UICollectionGridViewLayout4()
        super.init(collectionViewLayout: layout)
        layout.viewController = self
        collectionView!.backgroundColor = UIColor.white
        collectionView!.register(UICollectionGridViewCell.self,
                                      forCellWithReuseIdentifier: "cell")
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.isDirectionalLockEnabled = true
        //collectionView!.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
        collectionView!.bounces = false
    }
     
    required init?(coder aDecoder: NSCoder) {
        fatalError("UICollectionGridViewController.init(coder:) has not been implemented")
    }
     
    //设置列头数据
    func setColumns(columns: [String]) {
        cols = columns
    }
     
    //添加行数据
    func addRow(row: [Any]) {
        rows.append(row)
        collectionView!.collectionViewLayout.invalidateLayout()
        collectionView!.reloadData()
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Database()
    }
     
    override func viewDidLayoutSubviews() {
        collectionView!.frame = CGRect(x:0, y:0,
                                       width:view.frame.width, height:view.frame.height)
    }
     
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
     
    //返回表格总行数
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
            if cols.isEmpty {
                return 0
            }
            //总行数是：记录数＋1个表头
            return rows.count + 1
    }
     
    //返回表格的列数
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return cols.count
    }
     
    //单元格内容创建
    override func collectionView(_ collectionView: UICollectionView,
                            cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",for: indexPath) as! UICollectionGridViewCell
         
        //设置列头单元格，内容单元格的数据
        if indexPath.section == 0 {
            cell.label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
            cell.label.text = cols[indexPath.row]
            cell.label.textColor = UIColor.white
        } else {
            cell.label.font = UIFont.systemFont(ofSize: 15)
            cell.label.text = "\(rows[indexPath.section-1][indexPath.row])"
            cell.label.textColor = UIColor.black
        }
         
        //表头单元格背景色
        if indexPath.section == 0 {
            cell.backgroundColor = UIColor(red: 0x91/255, green: 0xDA/255,
                                           blue: 0x51/255, alpha: 1)
            //排序列列头显示升序降序图标
            if indexPath.row == selectedColIdx {
                let iconType = asc ? FAType.FALongArrowUp : FAType.FALongArrowDown
                cell.imageView.setFAIconWithName(icon: iconType, textColor: UIColor.white)
            }else{
                cell.imageView.image = nil
            }
        }
        //内容单元格背景色
        else {
            //排序列的单元格背景会变色
            if indexPath.row == selectedColIdx {
                //排序列的单元格背景会变色
                cell.backgroundColor = UIColor(red: 0xCC/255, green: 0xF8/255,
                                               blue: 0xFF/255, alpha: 1)
            }
            //数据区域每行单元格背景色交替显示
            else if indexPath.section % 2 == 0 {
                cell.backgroundColor = UIColor(white: 242/255.0, alpha: 1)
            } else {
                cell.backgroundColor = UIColor.white
            }
        }
         
        return cell
    }
     
    //单元格选中事件
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        //打印出点击单元格的［行,列］坐标
        print("点击单元格的[行,列]坐标: [\(indexPath.section),\(indexPath.row)]")
        if indexPath.section == 0 && sortDelegate != nil {
            //如果点击的是表头单元格，则默认该列升序排列，再次点击则变降序排列，以此交替
            asc = (selectedColIdx != indexPath.row) ? true : !asc
            selectedColIdx = indexPath.row
            rows = sortDelegate?.sort(colIndex: indexPath.row, asc: asc, rows: rows)
            collectionView.reloadData()
            
        }
        else{
            if indexPath.section != 0{
                let cell = collectionView.cellForItem(at: indexPath) as! UICollectionGridViewCell
                var sno:IndexPath = indexPath
                var cno:IndexPath = indexPath
                
                sno.row = 1
                cno.row = 3
                let snoCell = collectionView.cellForItem(at: sno) as! UICollectionGridViewCell
                let cnoCell = collectionView.cellForItem(at: cno) as! UICollectionGridViewCell
                let stu_name = database.readTableStudent(id: Int64(snoCell.label.text!)!)!.name
                let course_name = database.readTableCourse(id: Int64(cnoCell.label.text!)!)!.name
                print(cell.label.text!)
                let alertView = SCLAlertView()
                let dailyGradeTextField = alertView.addTextField("平时成绩")
                let finalGradeTextField = alertView.addTextField("期末成绩")
                let proportionTextField = alertView.addTextField("平时成绩占比")
                dailyGradeTextField.keyboardType = .numberPad
                finalGradeTextField.keyboardType = .numberPad
                proportionTextField.keyboardType = .numberPad
                alertView.addButton("确定", action: {
                    let dailyGrade = Float(dailyGradeTextField.text!)!
                    let finalGrade = Float(finalGradeTextField.text!)!
                    let proportion = Float(proportionTextField.text!)!
                    let grade_temp = dailyGrade * proportion + finalGrade * (1-proportion)
                    let grade = Int64(lroundf(grade_temp))
                    self.database.tableSCUpdateItem(sno: Int64(snoCell.label.text!)!, cno: Int64(cnoCell.label.text!)!, grade: grade)
                    SCLAlertView().showSuccess("成绩录入成功！",closeButtonTitle: "好的")
                    
                    
                })
                alertView.showInfo("请输入学生\(stu_name)的\(course_name)成绩",closeButtonTitle: "取消")
                
            }
        }
    }
}
