//
//  GraphTipView.swift
//  SmartCampus
//
//  Created by sj on 2017/9/20.
//  Copyright © 2017年 sj. All rights reserved.
//

import UIKit

class GraphTipView: UIView {

    public var lineColor:UIColor = UIColor.lightGray
    public var lineWidth:CGFloat = 4.0

    init(frame: CGRect, lineWidth:CGFloat = 4.0, lineColor:UIColor = UIColor.lightGray) {
        
        self.lineColor = lineColor
        self.lineWidth = lineWidth
        
        super.init(frame: frame)
        backgroundColor = UIColor.clear
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
        aPath.move(to: CGPoint(x: 0, y: self.frame.height/2))
        
        // Draw the lines
        aPath.addLine(to: CGPoint(x: self.frame.maxX, y: self.frame.height/2))
      
        aPath.close() // 最后一条线通过调用closePath方法得到
        aPath.stroke() // Draws line 根据坐标点连线，不填充
        
        self.drawCircle()
    }
    
    func drawCircle() {
        let color = lineColor
        color.set() // 设置线条颜色
        
        let x = self.frame.width/2 - lineWidth
        let y = self.frame.height/2 - lineWidth
        let w = lineWidth*2
        let h = lineWidth*2
        let aPath = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: w, height: h))
        aPath.lineWidth = self.lineWidth
        aPath.fill()
    }
}
