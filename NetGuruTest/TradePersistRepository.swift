//
//  PersistTradesRepository.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 30/11/2020.
//

import Foundation
import RxSwift

public protocol TradePersistRepository{
    func save(trade: Trade)
}
