//
//  Trade.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 30/11/2020.
//

import Foundation

public struct Trade : Identifiable {
    public let id: Int
    let buyOrderId: Int
    let timestamp : String
    let price : Double
    let amount: Double
    let sentiment: Double
    
    init(id: Int,
         buyOrderId: Int,
         timestamp: String,
         price: Double,
         amount: Double) {
        self.id = id
        self.buyOrderId = buyOrderId
        self.timestamp = timestamp
        self.price = price
        self.amount = amount
        self.sentiment = -1
    }
    
    init(id: Int,
         buyOrderId: Int,
         timestamp: String,
         price: Double,
         amount: Double,
         sentiment: Double) {
        self.id = id
        self.buyOrderId = buyOrderId
        self.timestamp = timestamp
        self.price = price
        self.amount = amount
        self.sentiment = sentiment
    }
    
    func withSentiment(sentiment: Double) -> Trade{
        return Trade(
            id: self.id,
            buyOrderId: self.buyOrderId,
            timestamp: self.timestamp,
            price: self.price,
            amount: self.amount,
            sentiment: sentiment
        );
    }
}
