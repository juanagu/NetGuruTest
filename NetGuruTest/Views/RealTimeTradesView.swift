//
//  ContentView.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 30/11/2020.
//

import SwiftUI
import RxSwift
import Starscream

struct RealTimeTradesView: View {
    @ObservedObject var viewModel : RealTimeTradesViewModel
    
    init(viewModel: RealTimeTradesViewModel) {
        self.viewModel = viewModel;
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.trades, id: \.self) {
                TradeView(trade: $0)
            }.navigationBarTitle("Real Time Trades")
                .onAppear {
                    self.viewModel.fetch()
                }
        }
    }
}

struct TradeView: View {
    private let trade: Trade
    init(trade: Trade) {
        self.trade = trade
    }
    
    var body: some View {
        VStack {
            Text(trade.timestamp)
                    .font(.system(size: 12))
            Text(String(trade.price))
                    .font(.system(size: 14))
                    .foregroundColor(Color.blue)
            Text(String(trade.sentimental))
                    .font(.system(size: 12))
                    .foregroundColor(Color.orange)
        }
    }
}
