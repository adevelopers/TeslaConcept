//
//  LeftViewModel.swift
//  TeslaConcept
//
//  Created by Кирилл Худяков on 26.09.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import Foundation
import Combine


class LeftViewModel {
    let didTapTrackLocation: PassthroughSubject<Void, Never>
    let didTapCurrentLocation: PassthroughSubject<Void, Never>
    let didTapStartTrack: PassthroughSubject<Void, Never>
    let didTapStopTrack: PassthroughSubject<Void, Never>
    
    init(didTapTrack: PassthroughSubject<Void, Never>,
         didTapCurrent: PassthroughSubject<Void, Never>,
         didTapStartTrack: PassthroughSubject<Void, Never>,
         didTapStopTrack: PassthroughSubject<Void, Never>) {
        self.didTapTrackLocation = didTapTrack
        self.didTapCurrentLocation = didTapCurrent
        self.didTapStartTrack = didTapStartTrack
        self.didTapStopTrack = didTapStopTrack
    }
}
