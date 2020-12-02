//
//  GetTradesRealTimeWebSocketRepository.swift
//  NetGuruTest
//
//  Created by Juan Ignacio Agu on 30/11/2020.
//

import Foundation
import Starscream
import RxSwift

class GetRealTimeTradesWebSocketRepository: GetRealTimeTradesRepository, WebSocketDelegate{
    
    private let event = "trade"
    private let channel = "live_trades_btcusd"
    private let webSocketUrl = "wss://ws.bitstamp.net"
    
    private let server = WebSocketServer()
    private var socket: WebSocket!
    private var isConnected = false
    private var observer: AnyObserver<Trade>?

    func connect() -> Observable<Trade> {
        var request = URLRequest(url: URL(string: webSocketUrl)!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        
        return Observable<Trade>.create{
            observer in
            self.observer = observer;
            return Disposables.create()
        };
    }
    
    func disconnect(){
        socket.disconnect()
    }
    
    fileprivate func isTradeEvent(_ json: Dictionary<String,Any>?) -> Bool{
        if(json == nil) {return false;}
        let event : String = json!["event"] as! String;
        return event == self.event
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
                case .connected:
                    isConnected = true
                    sendMessageToSubscribe()
                    break
                case .disconnected:
                    isConnected = false
                    socket.connect()
                    break
                case .text(let string):
                    notifyNewTrade(string)
                case .binary(let data):
                    print("Received binary: \(data)")
                    break
                case .ping(_):
                    break
                case .pong(_):
                    break
                case .viabilityChanged(_):
                    break
                case .reconnectSuggested(_):
                    break
                case .cancelled:
                    isConnected = false
                case .error(let error):
                    isConnected = false
                    handleError(error)
                }
    }
    
    func handleError(_ error: Error?) {
        observer?.onError(error!)
    }
    
    fileprivate func sendMessageToSubscribe(){
        let jsonObject = [
            "event": "bts:subscribe",
            "data": ["channel": self.channel]
        ] as [String : Any]
        
        let jsonData = (try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted))!
        socket.write(data: jsonData)
    }
    
    fileprivate func notifyNewTrade(_ string: (String)) {
        if let json = stringToJson(string: string){
            if(isTradeEvent(json)){
                let data = json["data"] as! Dictionary<String, Any>
                observer?.onNext(TradeDataMapper(json: data).toEntity())
            }
        }
    }
    
    fileprivate func stringToJson(string: String) -> Dictionary<String,Any>?{
        let data = string.data(using: .utf8)!
            do {
                return try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>;
            } catch let error as NSError {
                print(error)
            }
        return nil
    }
}
