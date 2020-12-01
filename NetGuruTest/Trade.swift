//
//  Trade.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 30/11/2020.
//

import Foundation

public struct Trade : Hashable {
    
    let buyOrderId: Int64
    let timestamp : String
    let price : Double
    let amount: Double
    let sentimental: Double
    
    init(buyOrderId: Int64,
         timestamp: String,
         price: Double,
         amount: Double) {
        self.buyOrderId = buyOrderId
        self.timestamp = timestamp
        self.price = price
        self.amount = amount
        self.sentimental = -1
    }
    
    init(buyOrderId: Int64,
         timestamp: String,
         price: Double,
         amount: Double,
         sentimental: Double) {
        self.buyOrderId = buyOrderId
        self.timestamp = timestamp
        self.price = price
        self.amount = amount
        self.sentimental = sentimental
    }
    
    func withSentimental(sentimental: Double) -> Trade{
        return Trade(
            buyOrderId: self.buyOrderId,
            timestamp: self.timestamp,
            price: self.price,
            amount: self.amount,
            sentimental: sentimental
        );
    }
}
