//
//  RealTimeTradesViewModel.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 01/12/2020.
//

import Foundation
import RxSwift

public class RealTimeTradesViewModel: ObservableObject {
    
    @Published private(set) var state = State.idle
    private var useCase: RealTimeTradesUseCase
    private let maxTradeCapacity = 1000;
    private var trades: [Trade] = []
    
    init(useCase: RealTimeTradesUseCase) {
        self.useCase = useCase
    }
    
    func fetch(){
        state = State.loading
        useCase.execute()
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe { (trade) in
                self.addTrade(trade: trade)
            } onError: { (error) in
                self.showError(error: error)
            }
        
    }
    
    public func addTrade(trade: Trade) {
        if(self.hasMaxCapacity()){
            self.trades.removeAll()
        }
        
        self.trades.append(trade)
        self.state = State.loaded(self.trades)
    }
    
    private func hasMaxCapacity() -> Bool {
        return self.trades.count == maxTradeCapacity
    }
    
    private func showError(error: Error){
        self.state = State.error(error, self.trades)
    }
}

// MARK: - Inner Types

extension RealTimeTradesViewModel {
    enum State {
        case idle
        case loading
        case loaded([Trade])
        case error(Error, [Trade])
    }
}
