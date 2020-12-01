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
    
    private let server = WebSocketServer()
    private var socket: WebSocket!
    private var isConnected = false
    private var observer: AnyObserver<Trade>?

    func connect() -> Observable<Trade> {
        var request = URLRequest(url: URL(string: "wss://ws.bitstamp.net")!)
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
    
    fileprivate func isTradeEvent(_ json: Dictionary<String,Any>) -> Bool{
        let event : String = json["event"] as! String;
        return event == "trade"
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
                case .connected(let headers):
                    isConnected = true
                    print("websocket is connected: \(headers)")
                    sendMessageToSubscribe()
                case .disconnected(let reason, let code):
                    isConnected = false
                    print("websocket is disconnected: \(reason) with code: \(code)")
                case .text(let string):
                    print("Received text: \(string)")
                    if let json = stringToJson(string: string){
                        if(isTradeEvent(json)){
                            observer?.onNext(jsonToTrade(json: json["data"] as! Dictionary<String, Any>))
                        }
                    }
                case .binary(let data):
                    print("Received data: \(data.count)")
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
            if let e = error as? WSError {
                print("websocket encountered an error: \(e.message)")
            } else if let e = error {
                print("websocket encountered an error: \(e.localizedDescription)")
            } else {
                print("websocket encountered an error")
            }
    }
    
    func sendMessageToSubscribe(){
        let jsonObject = [
            "event": "bts:subscribe",
            "data": ["channel":"live_trades_btcusd"]
        ] as [String : Any]
        
        let jsonData = (try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted))!
        socket.write(data: jsonData)
    }
    
    func stringToJson(string: String) -> Dictionary<String,Any>?{
        let data = string.data(using: .utf8)!
            do {
                return try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>;
            } catch let error as NSError {
                print(error)
            }
        return nil
    }
    
    func jsonToTrade(json: Dictionary<String,Any>) -> Trade {
        return Trade(
            buyOrderId: json["buy_order_id"] as! Int64,
            timestamp: json["timestamp"] as! String,
            price: json["price"] as! Double,
            amount: json["amount"] as! Double
        )
    }
    
}
