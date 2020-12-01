//
//  PriceAnalyzer.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 01/12/2020.
//

import Foundation

public protocol PriceAnalyzer{
    func execute(price: Double) -> Double
}
