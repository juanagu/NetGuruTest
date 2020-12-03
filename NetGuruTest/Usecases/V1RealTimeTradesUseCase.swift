//
//  V1RealTimeTradesUseCase.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 01/12/2020.
//

import Foundation
import RxSwift

public class V1RealTimeTradesUseCase : RealTimeTradesUseCase {
    
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
    
    public func execute() -> Observable<Trade> {
        getRealTimeTradesRepository
            .connect()
            .subscribe(onNext: { (trade) in
                let analyzedTrade = self.analyze(trade: trade)
                self.observer?.onNext(analyzedTrade)
                self.tradePersistRepository.save(trade: analyzedTrade)
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
    
    public func dispose() {
        disposeBag = DisposeBag()
        getRealTimeTradesRepository.disconnect()
    }
    
    private func analyze(trade: Trade) -> Trade{
        let sentiment = self.priceAnalyzer.execute(price: trade.price);
        return trade.withSentiment(sentiment: sentiment);
    }
}
