//
//  Database.swift
//  JSP-HBU
//
//  Created by 齐子佳 on 2020/4/26.
//  Copyright © 2020 齐子佳. All rights reserved.
//

import Foundation
import SQLite

struct Database {
    var db:Connection!
    
    struct student
    {
        var id:Int64
        var name:String
        var sex:String
        var age:Int64
        var department:String
        
        init(id:Int64,name:String,sex:String,age:Int64,department:String) {
            self.id = id
            self.name = name
            self.sex = sex
            self.age = age
            self.department = department
        }
    }
    
    struct admin {
        var id:Int64
        var name:String
        var department:String
        init(id:Int64,name:String,department:String) {
            self.id = id
            self.name = name
            self.department = department
        }
    }
    
    
    struct Course {
        var id:Int64
        var name:String
        var credit:Int64
        var pno:Int64
        
        init(id:Int64,name:String,credit:Int64,pno:Int64) {
            self.id = id
            self.name = name
            self.credit = credit
            self.pno = pno
        }
    }
    
    struct SC {
        var sno:Int64
        var cno:Int64
        var grade:Int64
        
        init(sno:Int64,cno:Int64,grade:Int64) {
            self.sno = sno
            self.cno = cno
            self.grade = grade
        }
    }
    
    init(){
        connectDatabase()
    }
    mutating func connectDatabase(filePath: String = "/Documents") -> Void {

            let sqlFilePath = NSHomeDirectory() + filePath + "/db.sqlite3"

            do { // 与数据库建立连接
                db = try Connection(sqlFilePath)
                print("与数据库建立连接 成功")
            } catch {
                print("与数据库建立连接 失败：\(error)")
            }
    }
    // ===================================== 灯光 =====================================
        let TABLE_LAMP = Table("table_lamp") // 表名称
        let TABLE_LAMP_ID = Expression<Int64>("lamp_id") // 列表项及项类型
        let TABLE_LAMP_ADDRESS = Expression<Int64>("lamp_address")
        let TABLE_LAMP_NAME = Expression<String>("lamp_name")
        let TABLE_LAMP_COLOR_VALUE = Expression<String>("lamp_colorValue")
        let TABLE_LAMP_LAMP_TYPE = Expression<Int64>("lamp_lampType")
        
    
        let TABLE_STUDENT = Table("student")
        let TABLE_STUDENT_ID = Expression<Int64>("student_id")
        let TABLE_STUDENT_PASSWORD = Expression<String>("student_pwd")
        let TABLE_STUDENT_NAME = Expression<String>("student_name")
        let TABLE_STUDENT_SEX = Expression<String>("student_sex")
        let TABLE_STUDENT_AGE = Expression<Int64>("student_age")
        let TABLE_STUDENT_DEPARTMENT = Expression<String>("student_department")
    
    
        let TABLE_ADMIN = Table("admin")
        let TABLE_ADMIN_ID = Expression<Int64>("admin_id")
        let TABLE_ADMIN_PASSWORD = Expression<String>("admin_pwd")
        let TABLE_ADMIN_NAME = Expression<String>("admin_name")
        let TABLE_ADMIN_DEPARTMENT = Expression<String>("admin_department")
    
    
        let TABLE_COURSE = Table("course")
        let TABLE_COURSE_ID = Expression<Int64>("course_id")
        let TABLE_COURSE_NAME = Expression<String>("course_name")
        let TABLE_COURSE_CERDIT = Expression<Int64>("course_credit")
        let TABLE_COURSE_PNO = Expression<Int64>("course_pno")
    
        let TABLE_SC = Table("SC")
        let TABLE_SC_Sno = Expression<Int64>("SC_Sno")
        let TABLE_SC_Cno = Expression<Int64>("SC_Cno")
        let TABLE_SC_GRADE = Expression<Int64>("SC_GRADE")

        // 建表
    
    func tableStudentCreate() -> Void{
        do{
            try db.run(TABLE_STUDENT.create{ table in
                table.column(TABLE_STUDENT_ID,primaryKey: true)
                table.column(TABLE_STUDENT_PASSWORD)
                table.column(TABLE_STUDENT_NAME)
                table.column(TABLE_STUDENT_SEX)
                table.column(TABLE_STUDENT_AGE)
                table.column(TABLE_STUDENT_DEPARTMENT)
            })
            print("创建Student表成功")
        }catch{
            print("创建Student表失败：\(error)")
        }
    }
    
    func tableAdminCreate() -> Void{
        do{
            try db.run(TABLE_ADMIN.create{ table in
                table.column(TABLE_ADMIN_ID,primaryKey: true)
                table.column(TABLE_ADMIN_PASSWORD)
                table.column(TABLE_ADMIN_NAME)
                table.column(TABLE_ADMIN_DEPARTMENT)
            })
            print("创建Admin表成功")
        }catch{
            print("创建Admin表失败：\(error)")
        }
    }
    
    func tableCourseCreate() -> Void{
        do{
            try db.run(TABLE_COURSE.create{ table in
                table.column(TABLE_COURSE_ID,primaryKey: true)
                table.column(TABLE_COURSE_NAME)
                table.column(TABLE_COURSE_PNO)
                table.column(TABLE_COURSE_CERDIT)
            })
            print("创建Course表成功")
        }catch{
            print("创建Course表失败：\(error)")
        }
    }
    
    func tableSCCreate() -> Void{
        do{
            try db.run(TABLE_SC.create{ table in
                table.column(TABLE_SC_Sno,references: TABLE_STUDENT,TABLE_STUDENT_ID)
                table.column(TABLE_SC_Cno,primaryKey: true)
                table.column(TABLE_SC_GRADE)
                
            })
            print("创建SC表成功")
        }catch{
            print("创建SC表失败：\(error)")
        }
    }
    
        // 插入
    
    func tableStudentInsertItem(id:Int64,password:String,name:String,sex:String,age:Int64,department:String) -> Void{
        
        let insert = TABLE_STUDENT.insert(TABLE_STUDENT_ID <- id,TABLE_STUDENT_PASSWORD <- password,TABLE_STUDENT_NAME <- name,TABLE_STUDENT_SEX <- sex,TABLE_STUDENT_AGE <- age,TABLE_STUDENT_DEPARTMENT <- department)
        do{
            _ = try db.run(insert)
            print("插入Student数据成功，学号为\(id)")
        }catch{
            print("插入Student数据失败，学号为\(id)，\(error)")
        }
        
    }
    
    func tableAdminInsertItem(id:Int64,password:String,name:String,department:String) -> Void{
           
           let insert = TABLE_ADMIN.insert(TABLE_ADMIN_ID <- id,TABLE_ADMIN_PASSWORD <- password,TABLE_ADMIN_NAME <- name,TABLE_ADMIN_DEPARTMENT <- department)
           do{
               _ = try db.run(insert)
               print("插入Admin数据成功，工号为\(id)")
           }catch{
               print("插入Student数据失败，工号为\(id)，\(error)")
           }
           
       }
    
    
    func tableCourseInsertItem(id:Int64,name:String,credit:Int64,pno:Int64) -> Bool{
        let insert = TABLE_COURSE.insert(TABLE_COURSE_ID <- id,TABLE_COURSE_NAME <- name,TABLE_COURSE_CERDIT <- credit,TABLE_COURSE_PNO <- pno)
        do{
            _ = try db.run(insert)
            print("插入Course数据成功，课程号为\(id)")
            return true
        }catch{
            print("插入Course数据失败，课程号为\(id)，\(error)")
            return false
        }
    }
    
    func tableSCInsertItem(sno:Int64,cno:Int64,grade:Int64) -> Bool{
        let insert = TABLE_SC.insert(TABLE_SC_Cno <- cno,TABLE_SC_Sno <- sno,TABLE_SC_GRADE <- grade)
        do{
            _ = try db.run(insert)
            print("插入SC数据成功，学号为\(sno)")
            return true
        }catch{
            print("插入SC数据失败，学号为\(sno)，\(error)")
            return false
        }
    }
    
        // 遍历
    
    func queryTableStudent() -> [student] {

        
        var studentArray = [student]()
        for item in (try! db.prepare(TABLE_STUDENT)){
            var s:student
            s = student(id: item[TABLE_STUDENT_ID], name: item[TABLE_STUDENT_NAME], sex: item[TABLE_STUDENT_SEX], age: item[TABLE_STUDENT_AGE], department: item[TABLE_STUDENT_DEPARTMENT])
            studentArray.append(s)
            
        }
        return studentArray
    }
    
    func queryTableCourse() -> [Course] {
        
        var courseArray = [Course]()
        for item in (try! db.prepare(TABLE_COURSE)){
            var c:Course
            c = Course(id: item[TABLE_COURSE_ID], name: item[TABLE_COURSE_NAME], credit: item[TABLE_COURSE_CERDIT], pno: item[TABLE_COURSE_PNO])
            courseArray.append(c)
        }
        
        return courseArray
    }
    
    func queryTableSC() -> [SC] {
        var SCArray = [SC]()
        for item in (try! db.prepare(TABLE_SC)){
            var sc:SC
            sc = SC(sno: item[TABLE_SC_Sno], cno: item[TABLE_SC_Cno], grade: item[TABLE_SC_GRADE])
            SCArray.append(sc)
        }
        
        return SCArray
    }
    func queryTableSC(student_id:Int64) -> [SC]{
        var SCArray = [SC]()
        for item in (try! db.prepare(TABLE_SC)){
            if item[TABLE_SC_Sno] == student_id{
            var sc:SC
            sc = SC(sno: item[TABLE_SC_Sno], cno: item[TABLE_SC_Cno], grade: item[TABLE_SC_GRADE])
                SCArray.append(sc)
            }
        }
        
        return SCArray
    }
        // 读取
    func searchTableStudent(id:Int64) -> Bool{
        for _ in try!
        db.prepare(TABLE_STUDENT.filter(TABLE_STUDENT_ID == id)){
            return true
        }
        return false
    }
    
    func searchTableAdmin(id:Int64) -> Bool{
           for _ in try!
           db.prepare(TABLE_ADMIN.filter(TABLE_ADMIN_ID == id)){
               return true
           }
           return false
    }
    func searchTableSC(course_id:Int64,student_id:Int64) -> Bool{
        for _ in try!
            db.prepare(TABLE_SC.filter(TABLE_SC_Cno == course_id && TABLE_SC_Sno == student_id)){
                return true
            }
        return false
    }
    
    func studentVertify(id:Int64,pwd:String) -> Bool{
        for item in try!
        db.prepare(TABLE_STUDENT.filter(TABLE_STUDENT_ID == id)){
            if(item[TABLE_STUDENT_PASSWORD] == pwd){
                return true
            }
            else
            {
                return false
            }
        }
        return false
    }
    
    func AdminVertify(id:Int64,pwd:String) -> Bool{
        for item in try!
        db.prepare(TABLE_ADMIN.filter(TABLE_ADMIN_ID == id)){
            if(item[TABLE_ADMIN_PASSWORD] == pwd){
                return true
            }
            else
            {
                return false
            }
        }
        return false
    }
    
    func readTableStudent(id:Int64) -> student?{
        var s:student?
        for item in try! db.prepare(TABLE_STUDENT.filter(TABLE_STUDENT_ID == id)){
            
            s = student(id: id, name: item[TABLE_STUDENT_NAME], sex: item[TABLE_STUDENT_SEX], age: item[TABLE_STUDENT_AGE], department: item[TABLE_STUDENT_DEPARTMENT])
        }
        return s
    }
    
    func readTableAdmin(id:Int64) -> admin?{
        var a:admin?
        for item in try! db.prepare(TABLE_ADMIN.filter(TABLE_ADMIN_ID == id)){
            
            a = admin(id: id, name: item[TABLE_ADMIN_NAME], department: item[TABLE_ADMIN_DEPARTMENT])
        }
        return a
    }
    
    func readTableCourse(id:Int64) -> Course?{
        var c:Course?
        for item in try! db.prepare(TABLE_COURSE.filter(TABLE_COURSE_ID == id)){
            c = Course(id: id, name: item[TABLE_COURSE_NAME], credit: item[TABLE_COURSE_CERDIT], pno: item[TABLE_COURSE_PNO])
        }
        return c
    }
    
    func readTableSC(cno:Int64,sno:Int64) -> SC?{
        var sc:SC?
        for item in try! db.prepare(TABLE_SC.filter(TABLE_SC_Cno == cno && TABLE_SC_Sno == sno)){
            sc = SC(sno: sno, cno: cno, grade: item[TABLE_SC_GRADE])
        }
        
        return sc
    }

    func tableSCUpdateItem(sno:Int64,cno:Int64,grade:Int64) -> Void{
        let item = TABLE_SC.filter(TABLE_SC_Cno == cno && TABLE_SC_Sno == sno)
        do{
            if try db.run(item.update(TABLE_SC_GRADE <- grade)) > 0{
                print("成绩更新成功")
            }else{
                print("没有发现该SC数据")
            }
        }catch{
                print("成绩更新失败")
            }
        }
        // 删除
        func tableLampDeleteItem(address: Int64) -> Void {
            let item = TABLE_LAMP.filter(TABLE_LAMP_ADDRESS == address)
            do {
                if try db.run(item.delete()) > 0 {
                    print("灯光\(address) 删除成功")
                } else {
                    print("没有发现 灯光条目 \(address)")
                }
            } catch {
                print("灯光\(address) 删除失败：\(error)")
            }
        }
    
    func tableSCDeleteItem(student_id:Int64,course_id:Int64) -> Bool{
        let item = TABLE_SC.filter(TABLE_SC_Cno == course_id && TABLE_SC_Sno == student_id)
        do{
            if try db.run(item.delete()) > 0{
                return true
            }
            else{
                return false
            }
        }catch{
            return false
        }
    }
    }
