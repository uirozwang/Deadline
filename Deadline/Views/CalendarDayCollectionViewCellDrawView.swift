//
//  CalendarDayCollectionViewCellDrawView.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/11/8.
//

import UIKit

class CalendarDayCollectionViewCellDrawView: UIView {
    
    let aDegree = CGFloat.pi / 180
    let lineWidth: CGFloat = 3
    let radius: CGFloat = 20
    
    var percentage: CGFloat = 0
    var signR: [CGFloat] = []
    var signG: [CGFloat] = []
    var signB: [CGFloat] = []
    //各分類的實際數量，需要再轉換到percentages
    var proportion: [CGFloat] = []
    var percentages: [CGFloat] = []
    
    let circleLayer: CAShapeLayer = {
        // 形状图层，初始化与属性配置
        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.gray.cgColor
//        circle.strokeEnd = 0.0
        return circle
    }()
    
    let percentageLayer: CAShapeLayer = {
        let percentage = CAShapeLayer()
        percentage.fillColor = UIColor.clear.cgColor
        percentage.strokeColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1).cgColor
        return percentage
    }()
    
    // 视图创建，通过指定 frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    // 视图创建，通过指定 storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(){
        backgroundColor = UIColor.yellow
        circleLayer.lineWidth = lineWidth
        percentageLayer.lineWidth = lineWidth
        
        // 添加上，要动画的图层
        layer.addSublayer(circleLayer)
        layer.addSublayer(percentageLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 考虑到视图的布局，如通过 auto layout,
        // 需动画图层的布局，放在这里
        
        let circlePath = UIBezierPath(ovalIn: CGRect(x: lineWidth,
                                                     y: lineWidth,
                                                     width: radius*2,
                                                     height: radius*2))
        /*
        let percentagePath = UIBezierPath(arcCenter: CGPoint(x: lineWidth + radius, y: lineWidth + radius),
                                          radius: radius,
                                          startAngle: aDegree * startDegree,
                                          endAngle: aDegree * (startDegree + 360 * percentage / 100),
                                          clockwise: true)
        */
        var startDegree: CGFloat = 270
        let center = CGPoint(x: lineWidth + radius, y: lineWidth + radius)
        
        var i = 0
        
//        print(percentages)
//        print(signR)
        
        for percentage in percentages {
            let endDegree = startDegree + 360 * percentage / 100
            let percentagePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: aDegree * startDegree, endAngle: aDegree * endDegree, clockwise: true)
            let percentageLayer = CAShapeLayer()
            percentageLayer.path = percentagePath.cgPath
            percentageLayer.strokeColor = UIColor(red: signR[i], green: signG[i], blue: signB[i], alpha: 1).cgColor
            percentageLayer.lineWidth = lineWidth
            percentageLayer.fillColor = UIColor.clear.cgColor
            layer.addSublayer(percentageLayer)
            startDegree = endDegree
            
            i = i + 1
        }
        
        circleLayer.path = circlePath.cgPath
//        percentageLayer.path = percentagePath.cgPath
        
        if percentages.count == 0 {
            circleLayer.isHidden = true
            percentageLayer.isHidden = true
        } else {
            circleLayer.isHidden = false
            percentageLayer.isHidden = false
        }
    }
    
    // 动画的方法
    func animateCircle(duration t: TimeInterval) {
        // 画圆形，就是靠 `strokeEnd`
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // 指定动画时长
        animation.duration = t
        
        // 动画是，从没圆，到满圆
        animation.fromValue = 0
        animation.toValue = 1
        
        // 指定动画的时间函数，保持匀速
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        // 视图具体的位置，与动画结束的效果一致
        circleLayer.strokeEnd = 1.0
        
        // 开始动画
        circleLayer.add(animation, forKey: "animateCircle")
    }
    
}
