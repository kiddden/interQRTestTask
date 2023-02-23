//
//  DoorCell.swift
//  InterQRTestTask
//
//  Created by Eugene Ned on 22.02.2023.
//

import UIKit
import SnapKit

class DoorCell: UICollectionViewCell {
    
    private let protectionStatus: UIView = {
        let view = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Colors.safeGradientStart, Colors.safeGradientEnd]
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 41, height: 41)
        gradientLayer.cornerRadius = 20.5
        
        view.layer.addSublayer(gradientLayer)
        return view
    }()
    
    private let protectionImage: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let doorStatusImage: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        var view = UILabel()
        view.textColor = Colors.doorName
        view.font = UIFont.boldSystemFont(ofSize: 16)
        
        return view
    }()
    private let locationLabel: UILabel = {
        var view = UILabel()
        view.textColor = Colors.doorLocation
        view.font = UIFont.systemFont(ofSize: 14)
        
        return view
    }()
    
    let statusLabel: UILabel = {
        var view = UILabel()
        view.textColor = Colors.doorStatusLocked
        view.font = UIFont.boldSystemFont(ofSize: 15)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = Colors.cellBorder
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
        contentView.addSubviews(protectionStatus, nameLabel, locationLabel, statusLabel, doorStatusImage)
        protectionStatus.addSubview(protectionImage)

        protectionStatus.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.leading.equalToSuperview().offset(27)
            make.height.equalTo(41)
            make.width.equalTo(41)
        }
        
        protectionImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
//            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.leading.equalTo(protectionStatus.snp.trailing).offset(14)
        }

        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(0)
            make.leading.equalTo(protectionStatus.snp.trailing).offset(14)
        }
        
        doorStatusImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-28)
            make.height.equalTo(45)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(27)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    func configure(with door: Door) {
        nameLabel.text = door.name
        locationLabel.text = door.location
        statusLabel.text = getStatusText(for: door.status)
        statusLabel.textColor = getStatusColor(for: door.status)
        doorStatusImage.image = getDoorStatusImage(for: door.status)
        protectionImage.image = getProtectionImage(for: door.status)
        setProtectionStatusGradient(for: door.status)
    }

    private func getStatusText(for status: DoorStatus) -> String {
        switch status {
        case .locked:
            return "Locked"
        case .unlocking:
            return "Unlocking..."
        case .unlocked:
            return "Unlocked"
        }
    }
    
    private func getDoorStatusImage(for status: DoorStatus) -> UIImage {
        switch status {
        case .locked:
            return Images.doorClosed!
        case .unlocking:
            return Images.doorUnlocking!
        case .unlocked:
            return Images.doorOpen!
        }
    }

    private func getStatusColor(for status: DoorStatus) -> UIColor {
        switch status {
        case .locked:
            return Colors.doorStatusLocked
        case .unlocking:
            return Colors.doorStatusUnlocking
        case .unlocked:
            return Colors.doorStatusUnlocked
        }
    }
    
    private func getProtectionImage(for status: DoorStatus) -> UIImage {
        switch status {
        case .locked:
            return Images.protectionSafe!
        case .unlocking:
            return Images.protectionUnkown!
        case .unlocked:
            return Images.protectionUnsafe!
        }
    }
    
    private func setProtectionStatusGradient(for status: DoorStatus) {
        if let gradientLayer = protectionStatus.layer.sublayers?.first as? CAGradientLayer {
            switch status {
            case .locked:
                gradientLayer.colors = [Colors.safeGradientStart, Colors.safeGradientEnd]
            case .unlocking:
                gradientLayer.colors = [Colors.otherGradient, Colors.otherGradient]
            case .unlocked:
                gradientLayer.colors = [Colors.unsafeGradientStart, Colors.unsafeGradientEnd]
            }
        }
    }
}

