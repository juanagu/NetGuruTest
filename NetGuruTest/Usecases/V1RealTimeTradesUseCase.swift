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
    
    init(getRealTimeTradesRepository: GetRealTimeTradesRepository,
         priceAnalyzer : PriceAnalyzer){
        self.getRealTimeTradesRepository = getRealTimeTradesRepository
        self.priceAnalyzer = priceAnalyzer
    }
    
    func execute(input: Input) {
        getRealTimeTradesRepository
            .connect()
            .subscribe(
                onNext: { trade in
                    let sentimental = self.priceAnalyzer.execute(price: trade.price);
                    input.received(
                        output:
                            Output(
                                status: Status.fetch,
                                trade: trade.withSentimental(sentimental: sentimental)
                            )
                    )
                }
        )
    }
}
