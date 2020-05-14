//
//  SpiroScatterPlotData.swift
//  SpiroPlot
//
//  Created by Bhooshan Patil on 23/04/20.
//  Copyright © 2020 Developers. All rights reserved.
//

import Foundation
import UIKit
open class SpiroScatterPlotData: NSObject {
    
    internal var xValues:[NSNumber] = []
    internal var yValues:[NSNumber] = []
    internal var graphColor:UIColor = .blue
    
    @objc public init(xValues:[NSNumber],yValues:[NSNumber],graphColor:UIColor) {
        self.xValues = xValues;
        self.yValues =  yValues;
        self.graphColor = graphColor;
    }
}
