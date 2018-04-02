//
//  PerformanceGraphViewController.swift
//  SmartCampus
//
//  Created by sj on 2017/9/20.
//  Copyright © 2017年 sj. All rights reserved.
//

import UIKit

/*
 *任意多边形绘图举例
 *以同学在班级中各门功课表现为例
*/
class PerformanceGraphViewController: UIViewController {

    let studentColor = UIColor(red: 80/255, green: 145/255, blue: 207/255, alpha: 1.0)
    let averageColor = UIColor(red: 234/255, green: 113/255, blue: 43/255, alpha: 1.0)
    
    var titles:[String] = ["德", "智", "体", "美", "劳"]//titles中元素的个数表示需要绘制几边形
    var averageGrades:[CGFloat] = [72,64,68,66,70]//必须与titles中元素个数保持一致
    var studentGrades:[CGFloat] = [74,62,88,52,82]//必须与titles中元素个数保持一致
    var stdName:String = "张三"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "任意多边形绘图"
        self.view.backgroundColor = UIColor.white
        self.edgesForExtendedLayout = .init(rawValue: 0)
        self.initTipView()
        self.initGraphView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initTipView(){
        let itemW:CGFloat = UIScreen.main.bounds.width/6
        let itemH:CGFloat = 60
        let sep:CGFloat = 8
        var x:CGFloat = itemW/2
        let graphView1 = GraphTipView(frame: CGRect(x: x, y: itemH , width: itemW-sep*2, height: itemH), lineWidth: 4.0, lineColor: studentColor)
        x += itemW - sep
        let labelTip1 = UILabel(frame: CGRect(x: x, y: itemH, width: itemW + itemW/2, height: itemH))
        labelTip1.text = self.stdName//"平均"
        labelTip1.font = UIFont.systemFont(ofSize: 18.0)
        
        x += itemW + itemW/2 + sep
        let graphView2 = GraphTipView(frame: CGRect(x: x, y: itemH, width: itemW-sep*2, height: itemH), lineWidth: 4.0, lineColor: averageColor)
        
        x += itemW - sep
        let labelTip2 = UILabel(frame: CGRect(x: x, y: itemH, width: itemW + itemW/2, height: itemH))
        labelTip2.text = "平均"//self.stdName
        labelTip2.font = UIFont.systemFont(ofSize: 18.0)
        
        self.view.addSubview(graphView1)
        self.view.addSubview(graphView2)
        self.view.addSubview(labelTip1)
        self.view.addSubview(labelTip2)
    }
    
    func initGraphView(){
        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width*2/3, height: self.view.bounds.width*2/3)
        self.drawBasicGraph(frame: frame)
        
        //绘制平均数多边形，需要描点
        self.drawFocusGraph(frame: frame, grades:self.averageGrades, lineColor:averageColor, lineWidth:4.0, isDrawPoint:true)
        //绘制某个同学得分的多边形，需要描点
        self.drawFocusGraph(frame: frame, grades:self.studentGrades, lineColor:studentColor, lineWidth:4.0, isDrawPoint:true)
    }
    
    func drawFocusGraph(frame: CGRect, grades:[CGFloat], lineColor:UIColor, lineWidth:CGFloat, isDrawPoint:Bool){
        let view = PolygonView(frame: frame, grades: grades, lineColor:lineColor, lineWidth:lineWidth, isDrawPoint:isDrawPoint)
        view.center = self.view.center
        self.view.addSubview(view)
    }
    
    //画刻度标线
    func drawBasicGraph(frame:CGRect){
        let grades:[CGFloat] = [20,40,60,80,100]//总分100分，有五条刻度线
        
        for (index, grade) in grades.enumerated(){//画刻度线
            var array = [CGFloat]()//保存当前刻度线的分数值
            for _ in 0..<titles.count{
                array.append(grade)
            }
            
            //多边形控件，画刻度线，不用描点
            let view = PolygonView(frame: frame, grades:array)
            view.center = self.view.center
            self.view.addSubview(view)
            
            let itemW:CGFloat = 30
            var startPoint:CGPoint
            var endPoint:CGPoint
            if titles.count%2 == 1{
                startPoint = view.points[titles.count - 1]
                endPoint = view.points[0]
            }else{
                startPoint = view.points[titles.count - 2]
                endPoint = view.points[titles.count - 1]
            }
            let labelX = startPoint.x + (endPoint.x - startPoint.x)/2 - itemW/2 - 5
            let labelY = startPoint.y - (startPoint.y - endPoint.y)/2 - itemW/2 - 5
            
            //放置刻度值
            let label = UILabel(frame: CGRect(x: labelX, y: labelY, width: itemW, height: itemW))
            label.text = "\(Int(grade))"
            label.textColor = UIColor.lightGray
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12.0)
            view.addSubview(label)
        
            let centerX = view.frame.width/2
            let centerY = view.frame.height/2
            if index == grades.count - 1 {//如果是最大的一条刻度线，放置多边形顶点title
                for (index, title) in titles.enumerated(){
                    
                    let labelW:CGFloat = 40
                    let labelH:CGFloat = 40
                    var frame = view.bounds
                    
                    let currentP = view.points[index]
                    if currentP.x == centerX{
                        if currentP.y > centerY{
                            frame = CGRect(x: currentP.x - labelW/2, y: currentP.y + labelH, width: labelW, height: labelH)
                        }else{
                            frame = CGRect(x: currentP.x - labelW/2, y: currentP.y - labelH, width:labelW, height: labelH)
                        }
                    }else if currentP.x > centerX{
                        frame = CGRect(x: currentP.x, y: currentP.y - labelH/2, width: labelW, height: labelH)
                    }else{
                        frame = CGRect(x: currentP.x - labelW, y: currentP.y - labelH/2, width: labelW, height: labelH)
                    }
                    
                    let label = UILabel(frame:frame)
                    label.text = title
                    label.textColor = UIColor.black
                    label.textAlignment = .center
                    label.font = UIFont.systemFont(ofSize: 16.0)
                    view.addSubview(label)
                }
            }
        }
        
    }
}
