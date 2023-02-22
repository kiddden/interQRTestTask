//
//  Door.swift
//  InterQRTestTask
//
//  Created by Eugene Ned on 22.02.2023.
//

import Foundation

enum DoorStatus {
    case locked
    case unlocking
    case unlocked
}

struct Door {
    var id: String
    var name: String // Front door, garage door, etc
    var location: String // Home, office, parents house, etc
    var status: DoorStatus
}
