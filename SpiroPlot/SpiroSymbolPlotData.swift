//
//  SpiroSymbolPlotData.swift
//  SpiroPlot
//
//  Created by Bhooshan Patil on 23/04/20.
//  Copyright © 2020 Developers. All rights reserved.
//

import Foundation
import UIKit
import CorePlot

@objc open class SpiroSymbolPlotData: NSObject {
    
    internal var xValues:[NSNumber] = []
    internal var yValues:[NSNumber] = []
    internal var symbolColor:UIColor = .yellow
    internal var symbolStyle:CPTPlotSymbol = .plus()
    internal var symbolSize:CGSize = CGSize(width: 5, height: 5)
    
    
    @objc public init(xValues:[NSNumber],yValues:[NSNumber]) {
        self.xValues = xValues;
        self.yValues =  yValues;
    }
    @objc public func symbolStyle(style:CPTPlotSymbol) -> SpiroSymbolPlotData {
        self.symbolStyle = style
        return self
    }
    @objc public func symbolSize(size:CGSize) -> SpiroSymbolPlotData {
        self.symbolSize = size
        return self
    }
    @objc public func symbolColor(color:UIColor) -> SpiroSymbolPlotData {
        self.symbolColor = color
        return self
    }
    
}
