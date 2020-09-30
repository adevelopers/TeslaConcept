//
//  Store.swift
//  TeslaConcept
//
//  Created by Кирилл Худяков on 27.09.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import Foundation
import Combine

enum GoogleMapsViewState {
    case none
    case tracking
    case history
}


class Store {
    
    static let shared = Store()
    
    let didTapTrackLocation: PassthroughSubject<Void, Never> = .init()
    let didTapCurrentLocation: PassthroughSubject<Void, Never> = .init()
    let didTapStartTrack: PassthroughSubject<Void, Never> = .init()
    let didTapStopTrack: PassthroughSubject<Void, Never> = .init()
    let didTapPreviousTrack: PassthroughSubject<Void, Never> = .init()
    let speed: CurrentValueSubject<Double, Never> = .init(0)
    let state: CurrentValueSubject<GoogleMapsViewState, Never> = .init(.none)
}
