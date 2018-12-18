//
//  ViewController.swift
//  8-1
//
//  Created by student on 2018/11/10.
//  Copyright © 2018年 xh. All rights reserved.
//

import UIKit

//tableview样例里面还自定义了一个为什么？
//本例子利用section 区分 也可用 indexpath.row的奇偶数来区分
//cell为自定义的也可以在mainstoryboar里设置模版
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    //返回cell 数目
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0{   //section为0时 就是添加的老师的内容。作为一个标识
               return teachers.count
        }
        else{
               return students.count
         
        }
    }
    
    //设置cell样式
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier=tableTitle[indexPath.section]
        
        var cell=tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell==nil{
            //w若为teacher  则 style为.subtitle  否则为.default
            let style: UITableViewCell.CellStyle = (identifier == "Teacher") ? .subtitle : .default
            cell = UITableViewCell(style: style, reuseIdentifier: identifier)
            
            cell?.accessoryType = .disclosureIndicator//右边添加 上>

        }
        switch identifier {
        case "Teacher":
      
            cell?.textLabel?.text=teachers[indexPath.row].fullName
            cell?.detailTextLabel?.text=teachers[indexPath.row].title //细节 此处显示职称
        
            
        case "Student":
            
            cell?.textLabel?.text=students[indexPath.row].fullName
          
        default:
            break
        }
        return cell!
    }
    
    //需要指定section数 2个
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableTitle.count
    }
    //每一个section的头，来提示一些信息
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableTitle[section]
    }
    
    var students=[Student]()
    var teachers=[Teacher]()
    //定义表头数组
    var tableTitle=["Teacher","Student"]
    //定义一个表视图
    var table:UITableView!
    //右边按钮
    var rightItem:UIBarButtonItem! //自定义导航栏上button
    //弹出框
    var alert:UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title="mytable"
        
         //生成3个Teacher对象
        for i in 1...3{
            let temp=Teacher(title: "教授", firstName:"张", lastName: "\(i)", age: 21, gender: .female, department: .one)
            teachers.append(temp)
        }
        
        for i in 1..<5{
            let temp=Student(stuNo: 2015110100 + i, firstName: "李", lastName: "\(i)", age: 19, gender: .male, department: .two)
            students.append(temp)
        }
        
        //排序  fullname相同如何排序的
        teachers.sort{return $0.fullName  < $1.fullName}
        students.sort{
            return $0.fullName < $1.fullName
        }
        
         //创建表视图，并设置代理和数据源
        table=UITableView(frame: self.view.bounds)  //table的大小根self.view一样
        table.delegate=self
        table.dataSource=self  //手动设置代理以及
        self.view.addSubview(table)//添加tableviews的子视图
        
         //导航栏控制器右边的按钮
        rightItem=UIBarButtonItem(title: "编辑我呀", style: .plain, target: self, action: #selector(edit))
        self.navigationItem.rightBarButtonItem=rightItem
        
         //导航栏控制器左边的按钮
        let leftItem=UIBarButtonItem(title: "添加学生", style: .plain, target: self, action: #selector(addStudent))
        self.navigationItem.leftBarButtonItem=leftItem
        
        
    }
    //objc是什么意思 没有返回值吗
    @objc func addStudent(){
         //login那种框弹出  另一种是actionsheet
        alert=UIAlertController(title: "学生信息填写", message:"请填写完整",preferredStyle: .alert)
        alert.addTextField{
            (textField) in
            textField.placeholder="学生学号"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "学生姓"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "学生名"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "学生性别"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "学生年龄"
        }
        
        //注意handler的写法
        let okbutton=UIAlertAction(title: "确认", style: .default){
            (alert) in
            self.add()  //闭包里必须有self
        }
        
        let cancerbutton=UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(okbutton)
        alert.addAction(cancerbutton)
        
        //present用来展示uialertcontroller
        self.present(alert,animated: true,completion: nil)
      
    }
    
    //添加学生
    func add(){
        //uialertcontroler的textfield选取内容
        let no=Int(alert.textFields![0].text!)
        let firstName = alert.textFields![1].text!
        let lastName = alert.textFields![2].text!
        let gender:Gender
        switch alert.textFields![3].text!{
        case "男":
            gender = .male
        case "女":
            gender = .female
        default:
            gender = .unknow
        }
        //将字符串转换为整数
        let age = Int(alert.textFields![4].text!)

        let student = Student(stuNo: no! , firstName: firstName, lastName: lastName, age: age!, gender: gender)

        
        //添加入数据源
        students.append(student)
        table.reloadData() //建立的table刷新数据
        
    }
    
     /// 编辑表视图
    @objc func edit(){
        //跟删除那里人家版给你写好的一样
        
        //做取反的工作
        if table.isEditing{
            rightItem.title="编辑"
            table.isEditing=false

        }else{
            rightItem.title="完成"
            table.isEditing=true
        }
    }
    
    //横拉会有删除界面效果
    
    //好像不要这段也可以
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除我呀"
    }

    //真正实现删除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if  editingStyle == .delete {
            //通过section判断真正要删除的数据
            if indexPath.section==0{
                teachers.remove(at: indexPath.row)
            }
            else{
                students.remove(at: indexPath.row)
            }
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade) //图形界面删除的动画效果

        
    }
    
    //被选中的cell 弹出消息 didselectrowat
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category=tableTitle[indexPath.section]
        let name:String
        if indexPath.section==0{
            name=teachers[indexPath.row].fullName
        }
        else{
            name=students[indexPath.row].fullName
        }
        let message="you selceted \(category),name:\(name)"
        let alert=UIAlertController(title: "######系统提示####", message: message, preferredStyle: .alert)
        let okbtn=UIAlertAction(title: "确定", style: .default, handler: nil)
        alert.addAction(okbtn)
        self.present(alert,animated: true)
    }
    
    //实现单元格的移动 moverowat
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section != destinationIndexPath.section{
            tableView.reloadData()
        }
        else{
            if sourceIndexPath.section == 0{
                teachers.insert(teachers.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
            }
            else{
                students.insert(students.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
            }
        }
    }
    


}

