//
//  ManoeuvreParser.swift
//  SpiroPlot
//
//  Created by Bhooshan Patil on 23/04/20.
//  Copyright © 2020 Developers. All rights reserved.
//

import Foundation
// MARK: - SlowManoeuvre
struct Manoeuvre: Codable {
    let testType: String
    let graphReadings: [GraphReading]
    let calculatedFields: [String: Double]
    let isSelected, isBestGraph, isValid: Bool
}

// MARK: - GraphReading
struct GraphReading: Codable {
    let x, y: Double
}
