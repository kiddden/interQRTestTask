//
//  ViewController.swift
//  InterQRTestTask
//
//  Created by Eugene Ned on 22.02.2023.
//

import UIKit
import SnapKit

class DoorsVC: UIViewController {
    
    private let companyNameLabel: UILabel = {
        var view = UILabel()
        view.text = "Inter QR"
        
        return view
    }()
    
    private let welcomeLabel: UILabel = {
        let view = UILabel()
        view.text = "Welcome"
        view.font = UIFont.boldSystemFont(ofSize: 35)
        
        return view
    }()
    
    private let collectionViewLabel: UILabel = {
        var view = UILabel()
        view.text = "My doors"
        view.textColor = UIColor(red: 0.196, green: 0.216, blue: 0.333, alpha: 1)
        view.font = UIFont.systemFont(ofSize: 20)
        
        return view
    }()
    
    private let settingsButton: UIButton = {
        let view = UIButton()
        view.setTitle("Button", for: .normal)
        
        return view
    }()
    
    private let housesImage: UIImageView = {
        let view = UIImageView()
//        view.alpha = 0.8
        view.image = Images.houses
        
        return view
    }()
    
    // MARK: - Properties
    private var doors: [Door] = []
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        // Initialize the collection view and set its properties
        let view = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.register(DoorCell.self, forCellWithReuseIdentifier: "DoorCell")
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = true
        
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadDoorList()
    }
    
    // MARK: - Private functions
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviews(companyNameLabel, welcomeLabel, settingsButton, housesImage, collectionViewLabel, collectionView)//, tableView)
        
        companyNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(24)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(companyNameLabel.snp.bottom).offset(63)
            make.leading.equalToSuperview().offset(24)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.centerY.equalTo(companyNameLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-27)
        }
        
        housesImage.snp.makeConstraints { make in
            make.top.equalTo(settingsButton.snp.bottom)
            make.trailing.equalToSuperview()
        }
        
        collectionViewLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(100)
            make.leading.equalToSuperview().offset(25)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(collectionViewLabel.snp.bottom).offset(29)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }
    
    private func loadDoorList() {
        DoorAPIService.shared.getDoorList { [weak self] doors in
            self?.doors = doors
            self?.collectionView.reloadData()
        }
    }
    
    private func unlockDoor(at indexPath: IndexPath) {
        if doors[indexPath.row].status == .locked {
            doors[indexPath.row].status = .unlocking
            collectionView.reloadItems(at: [indexPath])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.doors[indexPath.row].status = .unlocked
                self.collectionView.reloadItems(at: [indexPath])
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.doors[indexPath.row].status = .locked
                    self.collectionView.reloadItems(at: [indexPath])
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc private func unlockDoorFromLabelTap(_ sender: UITapGestureRecognizer) {
        guard let indexPath = indexPath(for: sender) else { return }
        unlockDoor(at: indexPath)
    }
}

extension DoorsVC: UIGestureRecognizerDelegate {
    func indexPath(for gestureRecognizer: UITapGestureRecognizer) -> IndexPath? {
        let point = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point) {
            if collectionView.cellForItem(at: indexPath)?.frame.contains(point) == true {
                return indexPath
            }
        }
        return nil
    }
}

extension DoorsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return the size of each cell
        return CGSize(width: collectionView.bounds.width, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

extension DoorsVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items you want to display in the collection view
        return doors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoorCell", for: indexPath) as! DoorCell
        let door = doors[indexPath.row]
        cell.configure(with: door)
        
        let labelTapGesture = UITapGestureRecognizer(target: self, action: #selector(unlockDoorFromLabelTap(_:)))
        labelTapGesture.cancelsTouchesInView = false
        cell.statusLabel.isUserInteractionEnabled = true
        cell.statusLabel.addGestureRecognizer(labelTapGesture)
        
        return cell
    }
}

extension DoorsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        unlockDoor(at: indexPath)
    }
}
