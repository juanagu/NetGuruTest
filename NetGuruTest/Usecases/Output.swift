//
//  Output.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 30/11/2020.
//

import Foundation

public struct Output{
    var status: Status;
    var trade: Trade;
}

enum Status{
    case clear, fetch, error
}
