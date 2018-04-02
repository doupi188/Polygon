//
//  PolygonView.swift
//  SmartCampus
//
//  Created by sj on 2017/9/21.
//  Copyright © 2017年 sj. All rights reserved.
//

import UIKit

//多边形控件
class PolygonView: UIView {
    
    public var lineColor:UIColor = UIColor(red: 220/255, green: 219/255, blue: 220/255, alpha: 1.0)
    public var lineWidth:CGFloat = 1.0
    
    public var isDrawPoint:Bool = false
    
    public var points = [CGPoint]()
    
    
    //totalGrade:总分
    //grades:分数数组
    //lineColor:画线颜色
    //isDrawPoint:是否描点
    init(frame: CGRect, totalGrade:CGFloat = 100, grades:[CGFloat], lineColor:UIColor = UIColor.lightGray, lineWidth:CGFloat = 1.0, isDrawPoint:Bool = false) {
        
        self.lineColor = lineColor
        self.lineWidth = lineWidth
        self.isDrawPoint = isDrawPoint
        
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        
        points.removeAll()
        
        let totalRadius:CGFloat = (frame.width - 10)/2
        let cPoint = self.center
        
        let count = grades.count
        if count == 0{
            return
        }
        
        let angle:CGFloat = CGFloat((2*Double.pi)/Double(count))
        
        if count%2 == 1{//如果是奇数个点，布局点的位置
            //奇数个点，第一个点在中心点的正上方显示
            for (index, grade) in grades.enumerated(){
                let rr = totalRadius*grade/totalGrade//计算半径
                let x = rr*sin(angle*CGFloat(index)) + cPoint.x//点的X坐标
                let y = -rr*cos(angle*CGFloat(index)) + cPoint.y//点的Y坐标
                points.append(CGPoint(x: x, y: y))
            }
        }else if count%2 == 0{//如果是偶数个点
            //奇数个点，第一个点在中心点正上方偏右angle/2处显示
            let startAngle = angle/2
            for (index, grade) in grades.enumerated(){
                let rr = totalRadius*grade/totalGrade
                let x = rr*sin(startAngle + angle*CGFloat(index)) + cPoint.x
                let y = -rr*cos(startAngle + angle*CGFloat(index)) + cPoint.y
                points.append(CGPoint(x: x, y: y))
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        lineColor.set() // 设置线条颜色
        
        let aPath = UIBezierPath()
        
        aPath.lineWidth = lineWidth// 线条宽度
        aPath.lineCapStyle = .butt
        aPath.lineJoinStyle = .bevel
        
        // Set the starting point of the shape.
        aPath.move(to: points[0])
        
        // Draw the lines
        for index in 1..<points.count{
            aPath.addLine(to: points[index])
        }
        aPath.close() // 最后一条线通过调用closePath方法得到
        
        aPath.stroke() // Draws line 根据坐标点连线，不填充
        //        aPath.fill() // Draws line 根据坐标点连线，填充
        
        if self.isDrawPoint{//中否需要描点
            self.drawCircle()
        }
    }
    
    func drawCircle() {//描点
        let color = lineColor
        color.set() // 设置线条颜色
        
        for point in points{
            let x = point.x - lineWidth
            let y = point.y - lineWidth
            let w = lineWidth*2
            let h = lineWidth*2
            let aPath = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: w, height: h))
            aPath.lineWidth = self.lineWidth
            aPath.fill()
        }
    }
}
