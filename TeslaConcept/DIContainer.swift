//
//  DIContainer.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 02.10.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit

class DIContainer {
    
    static let shared = DIContainer()
    
    lazy var mainController: SplitViewController = {
        
        let splitController = SplitViewController()
        splitController.viewControllers = [
            leftController,
            rightController
        ]
        return splitController
    }()
    
    lazy var leftController: LeftViewController = {
        let store = Store.shared
        return LeftViewController(viewModel: LeftViewModel.init(didTapTrack: store.didTapTrackLocation,
                                                         didTapCurrent: store.didTapCurrentLocation,
                                                         didTapStartTrack: store.didTapStartTrack,
                                                         didTapStopTrack: store.didTapStopTrack,
                                                         didTapPreviousTrack: store.didTapPreviousTrack,
                                                         speed: store.speed
                                                         ))
    }()
    
    lazy var rightController: RightViewController = {
        let store = Store.shared
        return RightViewController(viewModel: MapViewModel(didTapTrack: store.didTapTrackLocation,
                                                         didTapCurrent: store.didTapCurrentLocation,
                                                         didTapStartTrack: store.didTapStartTrack,
                                                         didTapStopTrack: store.didTapStopTrack,
                                                         didTapPreviousTrack: store.didTapPreviousTrack,
                                                         speed: store.speed
                                                         ))
    }()
    
    
    lazy var musicTracksController: MusicTracksViewController = {
        return MusicTracksViewController(viewModel: MusicTracksViewModel())
    }()
    
}
