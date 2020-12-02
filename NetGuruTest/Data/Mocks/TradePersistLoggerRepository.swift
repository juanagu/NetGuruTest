//
//  TradePersistLoggerRepository.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 01/12/2020.
//

import Foundation

public class TradePersistLoggerRepository : TradePersistRepository {
    public func save(trade: Trade) {
        print("trade saved: \(trade)")
    }
}
