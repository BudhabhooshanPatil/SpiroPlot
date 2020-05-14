//
//  CorePlotHelper.swift
//  iSpiro-CorePlot
//
//  Created by Bhooshan Patil on 20/04/20.
//  Copyright © 2020 Developers. All rights reserved.
//

import UIKit
import CorePlot

class CorePlotHelper: NSObject {
    
    private var maxXandY = CGPoint(x: 8.0, y: 24.0)
    private var minXandY = CGPoint(x: 0.0, y: -12.0)
    private var host:CPTGraphHostingView? = nil
    private var zoomable = false
    private var isReport = false
    private var is_show_grids = false
    private var axixColor:UIColor? = UIColor.red
    
    
    static var shared_instance_var:CorePlotHelper =  {
        return CorePlotHelper()
    }()
    
    class func sharedInstance() -> CorePlotHelper {
        return shared_instance_var
    }
    override init() {
        
    }
    public func host(withHost:CPTGraphHostingView) -> CorePlotHelper{
        self.host = withHost
        return self
    }
    public func maxXandY(maxXandY:CGPoint) -> CorePlotHelper {
        self.maxXandY = maxXandY
        return self
    }
    public func minXandY(minXandY:CGPoint) -> CorePlotHelper {
        self.minXandY = minXandY
        return self
    }
    
    public func zoomable(isZoomable:Bool) -> CorePlotHelper {
        self.zoomable = isZoomable
        return self
    }
    public func showgrids(isShow:Bool) -> CorePlotHelper {
        self.is_show_grids = isShow
        return self
    }
    public func axisColor(color:UIColor) -> CorePlotHelper {
        self.axixColor  = color
        return self
    }
    public func builder() -> Void {
        self.setup()
    }
    private func setup(){
        
        host?.allowPinchScaling = true
        let xyGraph = CPTXYGraph(frame: host!.frame)
        host?.hostedGraph = xyGraph
        xyGraph.paddingLeft = 0
        xyGraph.paddingTop = 0
        xyGraph.paddingRight = 0
        xyGraph.paddingBottom = 0
        
        xyGraph.plotAreaFrame?.paddingBottom = 30.0
        xyGraph.plotAreaFrame?.paddingLeft = 30.0
        xyGraph.plotAreaFrame?.paddingTop = 10.0
        xyGraph.plotAreaFrame?.paddingRight = 20.0
        
        let axisFormatter = NumberFormatter()
        axisFormatter.minimumIntegerDigits = 1
        axisFormatter.maximumFractionDigits = 1
        
        
        let plotSpace = xyGraph.defaultPlotSpace as? CPTXYPlotSpace
        if zoomable {
            host?.hostedGraph?.defaultPlotSpace?.allowsUserInteraction = true
            plotSpace?.globalXRange = CPTPlotRange(location: NSNumber(cgFloat: minXandY.x), length: NSNumber(cgFloat: maxXandY.x))
            plotSpace!.globalYRange = CPTPlotRange(location: NSNumber(cgFloat: minXandY.y), length: NSNumber(cgFloat: maxXandY.y))
        } else {
            host?.hostedGraph?.defaultPlotSpace?.allowsUserInteraction = false
        }
        plotSpace?.xRange = CPTPlotRange(location: NSNumber(cgFloat: minXandY.x), length: NSNumber(cgFloat: maxXandY.x))
        plotSpace?.yRange = CPTPlotRange(location: NSNumber(cgFloat: minXandY.y), length: NSNumber(cgFloat: maxXandY.y))
        
        let textStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor(cgColor: self.axixColor!.cgColor)
        textStyle.fontName = "HelveticaNeue-Bold"
        textStyle.fontSize = 8.0
        textStyle.textAlignment = .center
        
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineWidth = 1.0
        lineStyle.lineColor = CPTColor(cgColor: self.axixColor!.cgColor)
        
        let axisSet = xyGraph.axisSet as? CPTXYAxisSet
        //    float interval = maxXValue.floatValue/5.0;
        let xAxis = axisSet?.xAxis
        xAxis?.majorIntervalLength = NSNumber(value: 1)
        xAxis?.minorTickLineStyle = nil
        xAxis?.labelingPolicy = .fixedInterval
        xAxis?.labelTextStyle = .init(style: textStyle)
        xAxis?.labelFormatter = axisFormatter
        if isReport {
            xAxis?.orthogonalPosition = minXandY.y as NSNumber
        } else {
            xAxis?.orthogonalPosition = 0
        }
        xAxis?.axisLineStyle = lineStyle
        
        let yAxis = axisSet?.yAxis
        
        if minXandY.y == -12 {
            yAxis?.majorIntervalLength = NSNumber(value: 3)
        } else {
            yAxis?.majorIntervalLength = NSNumber(value: 1)
        }
        
        yAxis?.minorTickLineStyle = nil
        yAxis?.labelingPolicy = .fixedInterval
        yAxis?.labelTextStyle = textStyle
        yAxis?.labelFormatter = axisFormatter
        yAxis?.orthogonalPosition = minXandY.x as NSNumber
        yAxis?.axisLineStyle = lineStyle
        
        if self.is_show_grids {
            let c = Int(0.3)
            lineStyle.lineColor = CPTColor(componentRed: CGFloat(c), green: CGFloat(c), blue: CGFloat(c), alpha: 1)
            lineStyle.lineWidth = 0.1
            xAxis?.minorGridLineStyle = lineStyle
            yAxis?.minorGridLineStyle = lineStyle
        }
        
    }
    func configurePlot(withHost host: CPTGraphHostingView?, andIdentifier identifier: String?, withDataSourceDelegate classObj: Any?) -> CPTPlot? {
        let xyGraph = host?.hostedGraph
        
        let scatterPlot = CPTScatterPlot()
        scatterPlot.dataSource = classObj as? CPTPlotDataSource
        scatterPlot.interpolation = .linear
        scatterPlot.identifier = identifier as (NSCoding & NSCopying & NSObjectProtocol)?
        
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineWidth = 3.0
        lineStyle.lineColor = CPTColor.blue()
        scatterPlot.dataLineStyle = lineStyle
        
        scatterPlot.areaFill = CPTFill(color: CPTColor.blue())
        
        scatterPlot.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        xyGraph?.add(scatterPlot, to: xyGraph?.defaultPlotSpace)
        return scatterPlot
    }
}

