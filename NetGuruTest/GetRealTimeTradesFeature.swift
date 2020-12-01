//
//  GetRealTimeTradesFeature.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 01/12/2020.
//

import Foundation
import SwiftUI

public class GetRealTimeTradesFeature{
    
    func build() -> RealTimeTradesView
    {
        return RealTimeTradesView(viewModel: provideViewModel())
    }
    
    fileprivate func provideViewModel() -> RealTimeTradesViewModel
    {
        return RealTimeTradesViewModel(useCase: provideUseCase())
    }
    
    fileprivate func provideUseCase() -> RealTimeTradesUseCase
    {
        return V1RealTimeTradesUseCase(
            getRealTimeTradesRepository: provideGetRepository(),
            priceAnalyzer: providePriceAnalyzer())
    }
    
    fileprivate func provideGetRepository() -> GetRealTimeTradesRepository{
        return GetRealTimeTradesOrchestraRepository(repositories: provideRepositoryRules())
    }
    
    fileprivate func providePriceAnalyzer() -> PriceAnalyzer
    {
        return PriceAnalyzerWithML();
    }
    
    fileprivate func provideRepositoryRules() -> [RepositoryRule]
    {
        return [
            RepositoryRule(maxRecords: 10, repository: GetRealTimeTradesWebSocketRepository()),
            RepositoryRule(maxRecords: 5, repository: GetRealTimeTradesMockRepository()),
        ]
    }
}
