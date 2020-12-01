//
//  GetRealTradesRepository.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 30/11/2020.
//

import Foundation
import RxSwift

public protocol GetRealTimeTradesRepository{
    func connect() -> Observable<[Trade]>
}
