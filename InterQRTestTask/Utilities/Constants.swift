//
//  Constants.swift
//  InterQRTestTask
//
//  Created by Eugene Ned on 22.02.2023.
//

import UIKit

enum Images {
    // Door screen
    static let companyName = UIImage(named: "companyName")
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
    // Doors screen
    static let interLabel = UIColor(named: "interColor")!.cgColor
    
    // Door cell
    static let doorLocation = UIColor(named: "doorLocationColor")!
    static let doorName = UIColor(named: "doorNameColor")!
    static let doorStatusLocked = UIColor(named: "doorStatusLabelLockedColor")!
    static let doorStatusUnlocking = UIColor(named: "doorStatusLabelUnlockingColor")!
    static let doorStatusUnlocked = UIColor(named: "doorStatusLabelUnlockedColor")!
    
    static let cellBorder = UIColor(named: "cellBorderColor")!.cgColor
    static let otherGradient = UIColor(named: "otherGradientColor")!.cgColor
    static let safeGradientStart = UIColor(named: "safeGradientStartColor")!.cgColor
    static let safeGradientEnd = UIColor(named: "safeGradientEndColor")!.cgColor
    static let unsafeGradientStart = UIColor(named: "unsafeGradientStartColor")!.cgColor
    static let unsafeGradientEnd = UIColor(named: "unsafeGradientEndColor")!.cgColor
}
