//
//  RealTimeTradesUseCaseTests.swift
//  NetGuruTestTests
//
//  Created by Juan Ignacio Agu on 03/12/2020.
//

@testable import NetGuruTest
import XCTest
import RxSwift

class RealTimeTradesUseCaseTests: XCTestCase {
    
//    var testScheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
//        self.testScheduler = TestScheduler(initialClock: .zero)
        self.disposeBag = DisposeBag()
    }
    
    override func tearDown() {
//        useCase = V1RealTimeTradesUseCase(
//            getRealTimeTradesRepository: GetRealTimeTradesRepository,
//            priceAnalyzer: PriceAnalyzer,
//            tradePersistRepository: TradePersistRepository)
        super.tearDown()
    }
    
    func test_connect_with_valid_repository() throws{
    }
}
