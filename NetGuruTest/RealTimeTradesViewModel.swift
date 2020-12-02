//
//  RealTimeTradesViewModel.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 01/12/2020.
//

import Foundation

public class RealTimeTradesViewModel: ObservableObject, Input {
    
    @Published private(set) var state = State.idle
    private var useCase: RealTimeTradesUseCase
    private let maxTradeCapacity = 1000;
    private var trades: [Trade] = []
    
    init(useCase: RealTimeTradesUseCase) {
        self.useCase = useCase
    }
    
    func fetch(){
        state = State.loading
        useCase.execute(input: self)
    }
    
    public func received(output: Output) {
        if(self.hasMaxCapacity()){
            self.trades.removeAll()
        }
        
        self.trades.append(output.trade)

        DispatchQueue.main.async {
            self.state = State.loaded(self.trades)
        }
    }
    
    fileprivate func hasMaxCapacity() -> Bool {
        return self.trades.count == maxTradeCapacity
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
