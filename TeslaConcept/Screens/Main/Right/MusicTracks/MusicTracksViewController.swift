//
//  MusicTracksViewController.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 02.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import VanillaConstraints
import Combine


class MusicTracksViewController: UIViewController {
    let viewModel: MusicTracksViewModel
    private var cancelables: [AnyCancellable] = []
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Music tracks"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = RowLayout()
        layout.delegate = self
        
        let view =  UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(MusicTrackCell.self, forCellWithReuseIdentifier: MusicTrackCell.identifier)
        view.dataSource = self
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var playerHStack: UIView = {
        let view = UIView()
        
        let prevButton = UIImageView(image: UIImage(imageLiteralResourceName: "prevtrack"))
        let playButton = UIImageView(image: UIImage(imageLiteralResourceName: "play"))
        let nextButton = UIImageView(image: UIImage(imageLiteralResourceName: "nexttrack"))
        
        [prevButton, playButton, nextButton].forEach {
            $0.contentMode = .scaleAspectFit
        }
        
        prevButton
            .add(to: view)
            .left(to: \.leftAnchor, constant: 0)
            .centerY(to: \.centerYAnchor)
            .width(48)
            .height(48)
        playButton
            .add(to: view)
            .left(to: \.rightAnchor, of: prevButton, constant: 48)
            .centerY(to: \.centerYAnchor)
            .width(48)
            .height(48)
        nextButton
            .add(to: view)
            .left(to: \.rightAnchor, of: playButton, constant: 48)
            .centerY(to: \.centerYAnchor)
            .width(48)
            .height(48)
        return view
    }()
    
    init(viewModel: MusicTracksViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundPanel")
        
        titleLabel
            .add(to: view)
            .top(to: \.topAnchor, constant: 16)
            .centerX(to: \.centerXAnchor)
        
        collectionView
            .add(to: view)
            .top(to: \.bottomAnchor, of: titleLabel, constant: 32, priority: .defaultHigh)
            .left(to: \.leftAnchor, constant: 16)
            .right(to: \.rightAnchor, constant: 16)
            .height(406)
        
        playerHStack
            .add(to: view)
            .top(to: \.bottomAnchor, of: collectionView, constant: 32, priority: .defaultHigh)
            .centerX(to: \.centerXAnchor)
            .width(240)
            .height(48)
        
        viewModel.tracks
            .sink(receiveValue: updateCollectiionView)
            .store(in: &cancelables)
        
        viewModel.loadData()
    }
    
    private func updateCollectiionView(_ tracks: [UIImage]) {
        print("tracks", tracks.count)
        collectionView.reloadData()
    }
    
}

extension MusicTracksViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tracks.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicTrackCell.identifier, for: indexPath) as? MusicTrackCell {
            
            cell.imageView.image = viewModel.tracks.value[indexPath.row]
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}

extension MusicTracksViewController: RowLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize {
        let width = viewModel.tracks.value[indexPath.row].size.width
        let height = viewModel.tracks.value[indexPath.row].size.height
        return CGSize(width: width, height: height)
    }
}

