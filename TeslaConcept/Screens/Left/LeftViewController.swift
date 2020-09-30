//
//  LeftViewController.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 24.09.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import VanillaConstraints
import Combine


final class LeftViewController: UIViewController {
    
    private lazy var speedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var trackLocationButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setImage(UIImage(imageLiteralResourceName: "trackLocation"), for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var currentLocationButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setImage(UIImage(imageLiteralResourceName: "location"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(imageLiteralResourceName: "Tesla")
        return view
    }()
    
    private lazy var startTrackButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Новый трек", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var stopTrackButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Закончить трек", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var previousTrackButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Предыдущий маршрут", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var buttonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalCentering
        stackView.addArrangedSubview(startTrackButton)
        stackView.addArrangedSubview(stopTrackButton)
        
        return stackView
    }()
    
    let viewModel: LeftViewModel
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: LeftViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speedLabel.text = "Скорость"
        setupUI()
        setupSubscriptions()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(speedLabel)
        
        speedLabel
            .add(to: view)
            .top(to: \.topAnchor, constant: 48)
            .centerX(to: \.centerXAnchor)
        
        trackLocationButton
            .add(to: view)
            .top(to: \.bottomAnchor, of: speedLabel, relation: .equal, constant: 16, priority: .defaultHigh)
            .left(to: \.leftAnchor, constant: 16)
            .height(48)
        
        currentLocationButton
            .add(to: view)
            .top(to: \.bottomAnchor, of: speedLabel, relation: .equal, constant: 16, priority: .defaultHigh)
            .left(to: \.rightAnchor, of: trackLocationButton, constant: 16)
            .height(48)
        
        buttonsStack
            .add(to: view)
            .top(to: \.bottomAnchor, of: trackLocationButton, relation: .equal, constant: 16, priority: .defaultHigh)
            .left(to: \.leftAnchor, constant: 16)
            .right(to: \.rightAnchor, constant: 16)
            .height(48)
        
        previousTrackButton
            .add(to: view)
            .top(to: \.bottomAnchor, of: buttonsStack, relation: .equal, constant: 16, priority: .defaultHigh)
            .left(to: \.leftAnchor, constant: 16)
//            .right(to: \.rightAnchor, constant: 16)
            .height(48)
        
            
        
        imageView
            .add(to: view)
            .centerY(to: \.centerYAnchor)
            .width(to: \.widthAnchor)
            .height(to: \.widthAnchor, multiplier: CGFloat(580/353))
        
    }
    
    @objc
    private func didTap(_ button: UIButton) {
        switch button {
        case trackLocationButton:
            viewModel.didTapTrackLocation.send()
        case currentLocationButton:
            viewModel.didTapCurrentLocation.send()
        case startTrackButton:
            print("startTrackButton")
            viewModel.didTapStartTrack.send()
        case stopTrackButton:
            print("stopTrackButton")
            viewModel.didTapStopTrack.send()
        case previousTrackButton:
            print("Предыдущий маршрут")
            viewModel.didTapPreviousTrack.send()
        default:
            ()
        }
    }
    
    private func setupSubscriptions() {
        viewModel.speed
            .filter({ $0 > 0 } )
            .map { "\($0) mps" }
            .assign(to: \.text, on: speedLabel)
            .store(in: &cancellables)
            
    }
    
}


