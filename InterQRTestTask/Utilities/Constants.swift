//
//  Constants.swift
//  InterQRTestTask
//
//  Created by Eugene Ned on 22.02.2023.
//

import UIKit

enum Images {
    // Door screen
    static let houses = UIImage(named: "houses")
    static let settings = UIImage(named: "gear")
    
    // Door cell
    static let protectionSafe = UIImage(named: "safeProtectionStatus")
    static let protectionUnsafe = UIImage(named: "unsafeProtectionStatus")
    static let protectionUnkown = UIImage(named: "otherProtectionStatus")
    static let doorOpen = UIImage(named: "openDoorStatus")
    static let doorUnlocking = UIImage(named: "unlockingDoorStatus")
    static let doorClosed = UIImage(named: "closedDoorStatus")
}

enum Colors {
    static let cellBorder = UIColor(named: "cellBorderColor")!.cgColor
    static let otherGradient = UIColor(named: "otherGradientColor")!.cgColor
    static let safeGradientStart = UIColor(named: "safeGradientStartColor")!.cgColor
    static let safeGradientEnd = UIColor(named: "safeGradientEndColor")!.cgColor
    static let unsafeGradientStart = UIColor(named: "unsafeGradientStartColor")!.cgColor
    static let unsafeGradientEnd = UIColor(named: "unsafeGradientEndColor")!.cgColor
}
