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
            completion(Door.moockData)
        }
    }
    
    func unlock(door: Door, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            completion()
        }
    }
}
