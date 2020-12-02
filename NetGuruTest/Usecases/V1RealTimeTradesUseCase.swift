//
//  V1RealTimeTradesUseCase.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 01/12/2020.
//

import Foundation
import RxSwift

class V1RealTimeTradesUseCase : RealTimeTradesUseCase {
    
    private var getRealTimeTradesRepository: GetRealTimeTradesRepository
    private var priceAnalyzer : PriceAnalyzer
    private var tradePersistRepository : TradePersistRepository
    private var observer: AnyObserver<Trade>?
    private var disposeBag = DisposeBag()
    
    init(getRealTimeTradesRepository: GetRealTimeTradesRepository,
         priceAnalyzer : PriceAnalyzer,
         tradePersistRepository : TradePersistRepository){
        self.getRealTimeTradesRepository = getRealTimeTradesRepository
        self.priceAnalyzer = priceAnalyzer
        self.tradePersistRepository = tradePersistRepository
    }
    
    func execute() -> Observable<Trade> {
        getRealTimeTradesRepository
            .connect()
            .subscribe(onNext: { (Trade) in
                let sentiment = self.priceAnalyzer.execute(price: Trade.price);
                let tradeWithSentiment = Trade.withSentiment(sentiment: sentiment);
                self.observer?.onNext(tradeWithSentiment)
                self.tradePersistRepository.save(trade: tradeWithSentiment)
            }, onError: { (Error) in
                self.observer?.onError(Error)
            }, onCompleted: {
                self.observer?.onCompleted()
            }, onDisposed: {
                
            }).disposed(by: disposeBag)
        
        
        return Observable<Trade>.create{
            observer in
            self.observer = observer;
            return Disposables.create()
        };
        
    }
}
