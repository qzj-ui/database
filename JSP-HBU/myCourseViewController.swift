//
//  myCourseViewController.swift
//  JSP-HBU
//
//  Created by 齐子佳 on 2020/5/20.
//  Copyright © 2020 齐子佳. All rights reserved.
//

import UIKit

protocol UICollectionGridViewSortDelegate3: class {
    func sort(colIndex: Int, asc: Bool, rows: [[Any]]) -> [[Any]]
}
class myCourseViewController: UIViewController,UICollectionGridViewSortDelegate3 {
    var database:Database!
    var gridViewController:UICollectionGridViewController3!
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
    
    @objc func update() -> Void{
        let courses = database.queryTableSC(student_id: stuID!)
        if courses.count == 0{
            please.isHidden = false
        }
        else{
            gridViewController = UICollectionGridViewController3()
            gridViewController.stuID = stuID
            gridViewController.sortDelegate = self
            gridViewController.setColumns(columns: ["课程编号","课程名", "课程学分", "课序号"])
            for course in courses{
                let id = Int64(course.cno)
                let c = database.readTableCourse(id: id)!
                gridViewController.addRow(row:[ c.id,c.name,c.credit,c.pno])
            }
            view.addSubview(gridViewController.view)
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        update()
    }
    var stuID:Int64?
    
    @IBOutlet weak var please: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        database = Database()
    }

}
//多列表格组件（通过CollectionView实现）
class UICollectionGridViewController3: UICollectionViewController {
    
    var stuID:Int64?
    
    var database:Database!
    //表头数据
    var cols: [String]! = []
    //行数据
    var rows: [[Any]]! = []
     
    //排序代理
    weak var sortDelegate: UICollectionGridViewSortDelegate3?
     
    //选中的表格列（-1表示没有选中的）
    private var selectedColIdx = -1
    //列排序顺序
    private var asc = true
     
    init() {
        //初始化表格布局
        let layout = UICollectionGridViewLayout3()
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
        }
        
        let name = NSNotification.Name(rawValue: "quitUpdate")
        NotificationCenter.default.post(name: name, object: nil)
    }
    
}