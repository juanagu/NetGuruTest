//
//  TradeDataMapper.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 01/12/2020.
//

import Foundation

public struct TradeDataMapper{
    
    let json : Dictionary<String,Any>;
    
    init(json: Dictionary<String,Any>){
        self.json = json
    }
    
    public func toEntity() -> Trade{
        return Trade(
            id: json["id"] as! Int,
            buyOrderId: json["buy_order_id"] as! Int,
            timestamp: json["timestamp"] as! String,
            price: json["price"] as! Double,
            amount: json["amount"] as! Double
        )
    }
}
