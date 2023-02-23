//
//  ViewController.swift
//  InterQRTestTask
//
//  Created by Eugene Ned on 22.02.2023.
//

import UIKit
import SnapKit

class DoorsVC: UIViewController {
    
    private let progressBar: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = Colors.doorStatusLocked
        
        return view
    }()
    
    private let companyNameLabel: UILabel = {
        let view = UILabel()
        let attributedText = NSMutableAttributedString(string: "Inter", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22), NSAttributedString.Key.foregroundColor: Colors.interLabel])
        attributedText.append(NSAttributedString(string: "QR", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22), NSAttributedString.Key.foregroundColor: Colors.doorStatusLocked]))
        view.attributedText = attributedText
        
        return view
    }()
    
    private let welcomeLabel: UILabel = {
        let view = UILabel()
        view.text = "Welcome"
        view.font = UIFont.boldSystemFont(ofSize: 35)
        view.textColor = .black
        
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
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = Colors.cellBorder
        view.layer.cornerRadius = 13
        view.setImage(Images.settings, for: .normal)
        view.imageView?.tintColor = .black
        view.imageView?.contentMode = .scaleAspectFit
        view.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return view
    }()
    
    private let housesImage: UIImageView = {
        let view = UIImageView()
        view.image = Images.houses
        
        return view
    }()
    
    // MARK: - Properties
    private var doors: [Door] = []
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
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
        configureVC()
        setupUI()
        loadDoorList()
    }
    
    // MARK: - Private functions
    
    private func configureVC() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: companyNameLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingsButton)
    }
    
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviews(companyNameLabel, welcomeLabel, settingsButton, housesImage, collectionViewLabel, collectionView)//, tableView)
        collectionView.addSubview(progressBar)
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(63)
            make.leading.equalToSuperview().offset(24)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(settingsButton.snp.width)
        }
        
        housesImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
        
        progressBar.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    private func loadDoorList() {
        self.progressBar.startAnimating()
        DoorAPIService.shared.getDoorList { [weak self] doors in
            self?.doors = doors
            self?.progressBar.stopAnimating()
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
