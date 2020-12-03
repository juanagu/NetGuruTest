//
//  ContentView.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 30/11/2020.
//

import Combine
import SwiftUI

struct RealTimeTradesView: View {
    @ObservedObject var viewModel : RealTimeTradesViewModel
    
    init(viewModel: RealTimeTradesViewModel) {
        self.viewModel = viewModel;
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationBarTitle("Real Time Trades")
        }
        .onAppear { self.viewModel.fetch() }
        .onDisappear { self.viewModel.dispose() }
    }
    
    
    var content: some View {
        switch viewModel.state {
        case .error(let error, let trades):
            return errorView(error: error, trades: trades).eraseToAnyView()
        case .loaded(let trades):
            return listView(of: trades).eraseToAnyView()
        default:
            return progressView().eraseToAnyView()
        }
    }
    
    private func listView(of trades: [Trade]) -> some View {
        return List(trades) { trade in
            TradeItemView(trade: trade)
        }
    }
    
    private func errorView(error: Error, trades : [Trade]) -> some View {
        HStack{
            Text(error.localizedDescription).eraseToAnyView()
            listView(of: trades)
        }
    }
    
    private func progressView() -> some View {
        return ProgressView()
    }
}

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
