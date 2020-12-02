//
//  GetTradesRealTimeMockRepository.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 01/12/2020.
//

import Foundation
import RxSwift

public class GetRealTimeTradesMockRepository : GetRealTimeTradesRepository {
    public func connect() -> Observable<Trade> {
        return Observable.from(fakeApiResult())
    }
    
    public func disconnect() {}
    
    fileprivate func fakeApiResult() -> [Trade]
    {
        return [Trade](repeating: makeFakeTrade(), count: 50)
    }
    
    fileprivate func makeFakeTrade() -> Trade{
        return Trade(
            id: randomInt(),
            buyOrderId: randomInt(),
            timestamp: "Fake: \(currentTimestamp())",
            price: randomDouble(),
            amount: randomDouble())
    }
    
    fileprivate func randomInt() -> Int {
        return Int.random(in: 1..<999999)
    }
    
    fileprivate func randomDouble() -> Double{
        return Double.random(in: 1..<2000)
    }
    
    fileprivate func currentTimestamp() -> String{
        return String(Int64(Date().timeIntervalSince1970 * 1000))
    }
    
}
