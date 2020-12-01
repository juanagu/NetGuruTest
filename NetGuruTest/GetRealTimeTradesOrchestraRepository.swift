//
//  GetTradesRealTimeOrchestraRepository.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 01/12/2020.
//

import Foundation
import RxSwift

public class GetRealTimeTradesOrchestraRepository : GetRealTimeTradesRepository{
    
    private var repositories : [RepositoryRule];
    private var index = 0;
    private var counter : Int = 0;
    private var observer: AnyObserver<Trade>?
    private var disposeBag = DisposeBag()

    init(repositories : [RepositoryRule]){
        self.repositories = repositories;
    }
    
    public func connect() -> Observable<Trade> {
        connectToCurrentRepository();
        return Observable<Trade>.create{
            observer in
            self.observer = observer;
            return Disposables.create()
        };
    }
    
    public func disconnect() {
        currentRepository().disconnect()
    }
    
    fileprivate func connectToCurrentRepository(){
        currentRepository().connect()
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(queue: .global()))
            .observe(on: ConcurrentDispatchQueueScheduler.init(queue: .global()))
            .subscribe (
                onNext: { trade in
                self.counter+=1;
                self.observer?.onNext(trade)
                self.checkIfNeedSwitchToRepository()
                }
            ).disposed(by: disposeBag);
    }
    
    fileprivate func currentRepository() -> GetRealTimeTradesRepository{
        return repositories[index].repository;
    }
 
    fileprivate func checkIfNeedSwitchToRepository(){
        if(repositories.capacity > 1 &&  counter == repositories[index].maxRecords){
            switchRepository()
        }
    }
    
    fileprivate func switchRepository() {
        if(index < repositories.capacity ){
            index+=1
        }else{
            index = 0
        }
        
        disposeBag = DisposeBag()
        connectToCurrentRepository()
    }
}

class RepositoryRule{
    let maxRecords : Int;
    let repository : GetRealTimeTradesRepository;
    
    init(maxRecords: Int,
         repository : GetRealTimeTradesRepository){
        self.maxRecords = maxRecords
        self.repository = repository
    }
}
