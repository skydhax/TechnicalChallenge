//
//  DetailBarChartCell.swift
//  Aniflix
//
//  Created by Daniel Reyes Sánchez on 05/11/17.
//  Copyright © 2017 Daniel Reyes Sánchez. All rights reserved.
//

import UIKit
import PNChart

class DetailBarChartCell:UITableViewCell, PNChartDelegate {
    
    
    lazy var barChart:PNBarChart = {
        let chart = PNBarChart(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        chart.labelFont = UIFont.systemFont(ofSize: 11)
        chart.labelTextColor = UIColor.white
        chart.showLabel = false
        chart.strokeColor = UIColor.black
        chart.delegate = self
        return chart
    }()
    
    
    var added = false
    
    var scoreDistribution:[Int:Int] = [Int:Int]() {
        didSet {
            if !added {
                let maxValue = scoreDistribution.max(by: {$0.value < $1.value})?.value ?? 100
                let sorted = scoreDistribution.sorted(by: { $0.key < $1.key })
                var xLabels = [Int]()
                var yValues = [Int]()
                for s in sorted {
                    xLabels.append(s.key)
                    yValues.append(s.value)
                }
                self.barChart.xLabels = xLabels
                self.barChart.yValues = yValues
                self.barChart.yLabels = [0,maxValue]
                addChart()
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    func addChart() {
        addSubview(barChart)
        barChart.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 16, paddingBottom: 0, width: 0, height: 0)
        barChart.stroke()
        layoutSubviews()
        self.added = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
