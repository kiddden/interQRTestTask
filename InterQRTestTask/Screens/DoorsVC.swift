//
//  ViewController.swift
//  InterQRTestTask
//
//  Created by Eugene Ned on 22.02.2023.
//

import UIKit
import SnapKit

class DoorsVC: UIViewController {
    
    private var shouldAnimateCollection = true
    
    private let animationDuration: Double = 1.0
    private let delayBase: Double = 1.0
    
    private let progressBar: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = Colors.doorStatusLocked
        
        return view
    }()
    
    private let companyNameImage: UIImageView = {
        let view = UIImageView()
        view.image = Images.companyName
        
        return view
    }()
    
    private let welcomeLabel: UILabel = {
        let view = UILabel()
        view.text = "Welcome"
        view.font = UIFont(name: "Sk-Modernist-Bold", size: 35)
        view.textColor = .black
        
        return view
    }()
    
    private let collectionViewLabel: UILabel = {
        var view = UILabel()
        view.text = "My doors"
        view.textColor = Colors.doorName
        view.font = UIFont(name: "Sk-Modernist-Bold", size: 20)
        
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
        view.contentMode = .scaleAspectFit
        
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: companyNameImage)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingsButton)
    }
    
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviews(welcomeLabel, housesImage, collectionViewLabel, collectionView)//, tableView)
        collectionView.addSubview(progressBar)
        
        companyNameImage.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.width.equalTo(86)
        }
        
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
            make.width.equalTo(UIScreen.main.bounds.width/2)
            make.height.equalTo(housesImage.snp.width)
            
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
            make.height.equalTo(50)
            make.width.equalTo(progressBar.snp.height)
        }
    }
    
    private func loadDoorList() {
        self.progressBar.startAnimating()
        DoorAPIService.shared.getDoorList { [weak self] doors in
            self?.doors = doors
            DispatchQueue.main.async {
                self?.progressBar.stopAnimating()
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func unlockDoor(at indexPath: IndexPath) {
        if doors[indexPath.row].status == .locked {
            self.doors[indexPath.row].status = .unlocking
            DispatchQueue.main.async { self.collectionView.reloadItems(at: [indexPath]) }
            DoorAPIService.shared.unlock(door: doors[indexPath.row]) {
                self.doors[indexPath.row].status = .unlocked
                DispatchQueue.main.async { self.collectionView.reloadItems(at: [indexPath]) }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.doors[indexPath.row].status = .locked
                    DispatchQueue.main.async {  self.collectionView.reloadItems(at: [indexPath]) }
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
        cell.contentView.transform = CGAffineTransform(translationX: 0, y: collectionView.bounds.height)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if shouldAnimateCollection { // To avoid animation when we scroll the collection view, thus it animates only when the VC appears
            cell.contentView.transform = CGAffineTransform(translationX: 0, y: collectionView.bounds.height)
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: [], animations: {
                cell.contentView.transform = .identity
            }, completion: { _ in
                self.shouldAnimateCollection = false
            })
        } else {
            cell.contentView.transform = .identity
        }
    }

}

extension DoorsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        unlockDoor(at: indexPath)
    }
}
