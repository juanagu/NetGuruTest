//
//  PriceAnalyzerWithML.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 01/12/2020.
//

import Foundation

public class PriceAnalyzerWithML : PriceAnalyzer {
    public func execute(price: Double) -> Double {
        do {
            let model = try BitcoinSentiment.init(configuration: .init())
            let output = try model.prediction(Price: price)
            return output.Sentiment
        } catch {
            return -1.0
        }
    }
}
