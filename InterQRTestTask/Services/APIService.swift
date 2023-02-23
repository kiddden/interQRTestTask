//
//  APIService.swift
//  InterQRTestTask
//
//  Created by Eugene Ned on 22.02.2023.
//

import Foundation

class DoorAPIService {
    
    static let shared = DoorAPIService()
    
    private init() { }
    
    func getDoorList(completion: @escaping ([Door]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            let doors = [
                Door(id: UUID().uuidString, name: "Front door", location: "Home", status: .locked),
                Door(id: UUID().uuidString, name: "Garage door", location: "Home", status: .locked),
                Door(id: UUID().uuidString, name: "Front door", location: "Office", status: .locked),
                Door(id: UUID().uuidString, name: "Back door", location: "Home", status: .locked)
            ]
            completion(doors)
        }
    }
    
    func unlock(door: Door, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            completion()
        }
    }
}
