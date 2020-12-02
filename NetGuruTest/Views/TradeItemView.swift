//
//  TradeView.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 01/12/2020.
//

import SwiftUI
struct TradeItemView: View {
    private let trade: Trade
    init(trade: Trade) {
        self.trade = trade
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack{
                label(title: "Timestamp:")
                Text(trade.timestamp)
                    .font(.system(size: 12))
            }
            HStack{
                label(title: "Price:")
                Text(String(trade.price))
                    .font(.system(size: 14))
            }
            HStack{
                label(title: "Sentiment:")
                Text(String(trade.sentiment))
                    .font(.system(size: 12))
                    .foregroundColor(Color.blue)
            }
        }
    }
    
    private func label(title: String) -> some View{
        return Text(title)
            .font(.system(size: 12))
    }
}
