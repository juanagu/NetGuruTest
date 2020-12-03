//
//  GetRealTimeTradesFeature.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 01/12/2020.
//

import Foundation
import SwiftUI

public struct GetRealTimeTradesFeature{
    
    func build() -> RealTimeTradesView
    {
        return RealTimeTradesView(viewModel: provideViewModel())
    }
    
    private func provideViewModel() -> RealTimeTradesViewModel
    {
        return RealTimeTradesViewModel(useCase: provideUseCase())
    }
    
    private func provideUseCase() -> RealTimeTradesUseCase
    {
        return V1RealTimeTradesUseCase(
            getRealTimeTradesRepository: provideGetRepository(),
            priceAnalyzer: providePriceAnalyzer(),
            tradePersistRepository: provideTradePersistRepository())
    }
    
    private func provideGetRepository() -> GetRealTimeTradesRepository{
        return GetRealTimeTradesOrchestraRepository(
            repositoryRules: provideRepositoryRules())
    }
    
    private func providePriceAnalyzer() -> PriceAnalyzer
    {
        return PriceAnalyzerWithML();
    }
    
    private func provideRepositoryRules() -> [RepositoryRule]
    {
        return [
            RepositoryRule(maxRecords: 100,
                           repository: GetRealTimeTradesWebSocketRepository()),
            RepositoryRule(maxRecords: 25,
                           repository: GetRealTimeTradesMockRepository()),
        ]
    }
    
    private func provideTradePersistRepository() -> TradePersistRepository{
        return TradePersistLoggerRepository()
    }
}
