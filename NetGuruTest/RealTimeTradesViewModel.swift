//
//  RealTimeTradesViewModel.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 01/12/2020.
//

import Foundation

public class RealTimeTradesViewModel: ObservableObject, Input {
    
    private var useCase: RealTimeTradesUseCase
    
    @Published var trades: [Trade] = []
    
    init(useCase: RealTimeTradesUseCase) {
        self.useCase = useCase
    }
    
    func fetch(){
        useCase.execute(input: self)
    }
    
    public func received(output: Output) {
        self.trades.append(output.trade)
    }
}
