//
//  NetGuruTestApp.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 30/11/2020.
//

import SwiftUI

@main
struct NetGuruTestApp: App {
    var body: some Scene {
        WindowGroup {
            GetRealTimeTradesFeature().build()
        }
    }
}
