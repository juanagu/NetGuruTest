//
//  V1RealTimeTradesUseCase.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 01/12/2020.
//

import Foundation

class V1RealTimeTradesUseCase : RealTimeTradesUseCase {
  
    private var getRealTimeTradesRepository: GetRealTimeTradesRepository
    private var priceAnalyzer : PriceAnalyzer
    private var tradePersistRepository : TradePersistRepository
    
    init(getRealTimeTradesRepository: GetRealTimeTradesRepository,
         priceAnalyzer : PriceAnalyzer,
         tradePersistRepository : TradePersistRepository){
        self.getRealTimeTradesRepository = getRealTimeTradesRepository
        self.priceAnalyzer = priceAnalyzer
        self.tradePersistRepository = tradePersistRepository
    }
    
    func execute(input: Input) {
        getRealTimeTradesRepository
            .connect()
            .subscribe(
                onNext: { trade in
                    let sentimental = self.priceAnalyzer.execute(price: trade.price);
                    let tradeWithSentimental = trade.withSentimental(sentimental: sentimental);
                    self.tradePersistRepository.save(trade: tradeWithSentimental)
                    input.received(
                        output:
                            Output(
                                status: Status.fetch,
                                trade: tradeWithSentimental
                            )
                    )
                }
        )
    }
}
