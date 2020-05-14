//
//  SpiroPlot.swift
//  iSpiro-CorePlot
//
//  Created by Bhooshan Patil on 20/04/20.
//  Copyright © 2020 Developers. All rights reserved.
//

import UIKit
import CorePlot

@objc open class SpiroPlot: NSObject {
    
    internal var axisColor = UIColor(red: 0.20, green: 0.71, blue: 0.90, alpha: 1.0)
    internal var host:CPTGraphHostingView!
    private var maxXandMaxY = CGPoint(x: 8.0, y: 24.0)
    private var minXandinY = CGPoint(x: 0.0, y: -12.0)
    internal var scatterPlotValues:[SpiroScatterPlotData]? = nil
    internal var symbolPlotvalues:[SpiroSymbolPlotData]? = nil
    
    
    internal lazy var lineStyle:CPTMutableLineStyle  = {
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineWidth = 1.0
        return lineStyle
    }()
    
    @objc public init(host:CPTGraphHostingView) {
        super.init()
        self.host = host
    }
    @objc public func setSpiroPlotData(values:[SpiroScatterPlotData]) ->SpiroPlot{
        self.scatterPlotValues = values;
        return self
    }
    @objc public func setPredicatedValues(values:[SpiroSymbolPlotData]) -> SpiroPlot {
        self.symbolPlotvalues = values
        return self
    }
    @objc init(host:CPTGraphHostingView,jsonFile:String){
        super.init()
        self.host = host
        self.readJsonForFile(fileName: jsonFile)
    }
    @objc public func graphLineColor(color:UIColor) -> SpiroPlot {
        self.axisColor = color
        return self
    }
    @objc public func maxXAndMaxY(maxXAndY:CGPoint) -> SpiroPlot {
        self.maxXandMaxY = maxXAndY
        return self
    }
    @objc public func minXAndMaxY(minXandY:CGPoint) -> SpiroPlot {
        self.minXandinY = minXandY
        return self
    }
    @objc public func build() {
        CorePlotHelper.sharedInstance().host(withHost: host).axisColor(color: self.axisColor).maxXandY(maxXandY: self.maxXandMaxY).minXandY(minXandY: self.minXandinY).builder()
        
        if let scatterPlotValues = self.scatterPlotValues  {
            
            for item in 0..<scatterPlotValues.count {
                
                let plot = CorePlotHelper.sharedInstance().configurePlot(withHost: host, andIdentifier: "plot:\(item)", withDataSourceDelegate: self)
                plot?.reloadData()
            }
        }
        if let symbolPlotValues = self.symbolPlotvalues  {
            
            for item in 0..<symbolPlotValues.count {
                
                let plot = CorePlotHelper.sharedInstance().configurePlot(withHost: host, andIdentifier: "symbol:\(item)", withDataSourceDelegate: self)
                plot?.reloadData()
            }
        }
        
    }
    
}
extension SpiroPlot : CPTPlotDataSource {
    
    public func numberOfRecords(for plot: CPTPlot) -> UInt {
        
        if let scatterPlotValues = self.scatterPlotValues ,let identifier = plot.identifier {
            for item in 0..<scatterPlotValues.count {
                
                if identifier.isEqual("plot:\(item)") {
                    return UInt(scatterPlotValues[item].xValues.count)
                }
            }
            if let symbolPlotValues = self.symbolPlotvalues , let identifier = plot.identifier {
                
                for item in 0..<symbolPlotValues.count {
                    
                    if identifier.isEqual("symbol:\(item)") {
                        return UInt(symbolPlotValues[item].xValues.count)
                    }
                }
            }
        }
        return 0;
    }
    public func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        
        let num = Int(idx)
        let myPlot = plot as? CPTScatterPlot
        
        if let scatterPlotValues = self.scatterPlotValues ,let identifier = plot.identifier {
            for item in 0..<scatterPlotValues.count {
                
                if identifier.isEqual("plot:\(item)") {
                    
                    lineStyle.lineColor = CPTColor(cgColor: scatterPlotValues[item].graphColor.cgColor)
                    myPlot?.dataLineStyle = lineStyle
                    
                    return (fieldEnum == 0) ? scatterPlotValues[item].xValues[num] : scatterPlotValues[item].yValues[num]
                    
                }
            }
        }
        if let symbolPlotValues = self.symbolPlotvalues ,let identifier = plot.identifier {
            for item in 0..<symbolPlotValues.count {
                
                if identifier.isEqual("symbol:\(item)") {
                    
                    myPlot?.dataLineStyle = nil
                    let symbol = symbolPlotValues[item].symbolStyle
                    symbol.size = symbolPlotValues[item].symbolSize
                    myPlot?.plotSymbol = symbol
                    lineStyle.lineColor = CPTColor(cgColor: symbolPlotValues[item].symbolColor.cgColor)
                    myPlot?.plotSymbol?.lineStyle = lineStyle
                    myPlot?.plotSymbol?.fill = CPTFill(color: CPTColor(cgColor: symbolPlotValues[item].symbolColor.cgColor))
                    return (fieldEnum == 0) ? symbolPlotValues[item].xValues[num] : symbolPlotValues[item].yValues[num]
                    
                }
            }
        }
        
        return 0;
    }
}

extension SpiroPlot {
    
    internal func readJsonForFile(fileName:String)
    {
        
        if let path = Bundle.main.url(forResource: fileName, withExtension: "json") {
            
            do {
                let data =  try Data(contentsOf: path)
                if let json = try? JSONDecoder().decode(Manoeuvre.self, from: data) {
                    var xValues:[NSNumber] = []
                    var yValues:[NSNumber] = []
                    for item in json.graphReadings {
                        xValues.append(NSNumber(value: item.x));
                        yValues.append(NSNumber(value: item.y))
                    }
                    self.scatterPlotValues = [SpiroScatterPlotData(xValues: xValues, yValues: yValues, graphColor: .red)]
                }
            } catch  {
                print(error)
            }
        }
    }
}
